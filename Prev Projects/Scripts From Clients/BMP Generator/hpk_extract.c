//
// hpk_extract - botman's HPK WAD extraction utility
//
// Copyright (C) 2001 - Jeffrey "botman" Broome
// (http://planethalflife.com/botman/)
//
// hpk_extract.c
//

#include <stdio.h>

/*
   HPK Header
   {
	  char identification[4];   // should be HPAK
	  int  num_hpk_tables;      // number of lump tables (???)
	  int  infotableofs;        // absolute offset to hpk lump table
   }

   HPK Section
   {
	  WAD3 Header
	  {
		 char identification[4];   // should be WAD3 or 3DAW
		 int  numlumps;
		 int  infotableofs;        // offset to lump table
	  }

	  Mip Section
	  {
		 First mip
		 {
			char name[16];
			unsigned width, height;
			unsigned offsets[4];  // mip offsets relative to start of this mip
			byte first_mip[width*height];
			byte second_mip[width*height/4];
			byte third_mip[width*height/16];
			byte fourth_mip[width*height/64];
			short int palette_size;
			byte palette[palette_size*3];
			short int padding;
		 }
		 Next mip {}
		 Next mip {}
		 .
		 .
		 .
		 Last mip {}
	  }

	  WAD Lump table
	  {
		 First WAD lump entry // 32 bytes in size
		 {
			int  filepos;     // file offset of mip
			int  disksize;    // size of mip in bytes
			int  size;        // uncompressed
			char type;        // 0x43 = WAD3 mip (Half-Life)
			char compression; // not used?
			char pad1, pad2;  // not used?
			char name[16];    // null terminated mip name
		 }
		 Next WAD lump {}
		 Next WAD lump {}
		 .
		 .
		 .
		 Last WAD lump {}
	  }
   }

   Next HPK Section {}
   Next HPK Section {}
   .
   .
   .
   Last HPK Section{}

   HPK Lump table
   {
	  int num_hpk_lumps    // number of HPK lumps in the table

	  First HPK lump entry // 32 bytes in size
	  {
		 char filename[64];  // name of cached file
		 int  ???;           // always 0x0003 ???
		 int  ???;           // always 0x0000 ???
		 int  hpk_section_size;        // size of the hpk section for this lump ???
		 unsigned char checksum_type;  // type of checksum??? (always 0x06 ???)
		 unsigned char md5_sum[16];    // MD5 checksum
		 unsigned char unused[3];      // don't know what this is ???
		 char unused[32];    // don't know what this is ???
		 int  timestamp[2];  // timestamp ???
		 int  filepos;       // file offset of hpk lump
		 int  hpk_lump_size; // size of hpk lump ???
	  }
	  Next HPK lump entry {}
	  Next HPK lump entry {}
	  .
	  .
	  .
	  Last HPK lump entry()
   }
*/

#define CMP_NONE  0
#define CMP_LZSS  1

#define TYP_NONE  0
#define TYP_LABEL 1
#define TYP_LUMPY 64    // 64 + grab command number


typedef struct
{
	char identification[4];   // should be HPAK
	int  num_hpk_tables;      // number of lump tables (???)
	int  infotableofs;        // absolute offset to hpk lump table
} hpk_header_t;

typedef struct
{
	char filename[64];  // name of cached file
	int  unknown1;
	int  unknown2;
	int  hpk_section_size;  // size of the hpk section for this lump (???)
	unsigned char checksum_type;  // type of checksum??? (always 0x06 ???)
	unsigned char md5_sum[16];    // MD5 checksum
	unsigned char unused[3];      // don't know what this is ???
	char unused1[32];        // don't know what this is (???)
	int  timestamp[2];      // time_t timestamp (???)
	int  filepos;           // file offset of hpk lump
	int  hpk_lump_size;     // size of hpk lump (???)
} hpk_lumpinfo_t;

typedef struct
{
	char  identification[4];   // should be WAD2 or 2DAW
	int   numlumps;
	int   infotableofs;
} wad_header_t;

typedef struct
{
	int   filepos;          // file offset of mip
	int   disksize;         // mip size
	int   size;             // uncompressed
	char  type;             // 0x43 = WAD3 mip (Half-Life)
	char  compression;      // not used?
	char  pad1, pad2;       // not used?
	char  name[16];         // must be null terminated
} wad_lumpinfo_t;

typedef struct
{
	char name[16];
	unsigned int width, height;
	unsigned int offsets[4];
} mip_info_t;

#ifndef __linux__
#pragma pack (1)
#endif

typedef struct rgb_s
{
	unsigned char rgbBlue;
	unsigned char rgbGreen;
	unsigned char rgbRed;
	unsigned char rgbReserved;
} rgb_t;

typedef struct bitmapfileheader_s
{
	short int     bfType;
	unsigned int  bfSize;
	short int     bfReserved1;
	short int     bfReserved2;
	unsigned int  bfOffBits;
#ifdef __linux__
} __attribute((packed)) bitmapfileheader_t;
#else
} bitmapfileheader_t;
#endif

typedef struct bitmapinfoheader_s
{
	unsigned int  biSize;
	long int      biWidth;
	long int      biHeight;
	short int     biPlanes;
	short int     biBitCount;
	unsigned int  biCompression;
	unsigned int  biSizeImage;
	long int      biXPelsPerMeter;
	long int      biYPelsPerMeter;
	unsigned int  biClrUsed;
	unsigned int  biClrImportant;
#ifdef __linux__
} __attribute((packed)) bitmapinfoheader_t;
#else
} bitmapinfoheader_t;
#endif


int filecount_mono;
int filecount_color;


void CreateBitmapFile(char* filename, int width, int height, unsigned char* buffer, rgb_t* palette)
{
	FILE* fp;
	bitmapfileheader_t hdr;
	bitmapinfoheader_t bih;
	int index;

	memset((void*)&bih, 0, sizeof(bih));

	bih.biWidth = width;
	bih.biHeight = height;

	bih.biSize = sizeof(bih);
	bih.biSizeImage = width * height;
	bih.biPlanes = 1;
	bih.biBitCount = 8;
	bih.biClrUsed = 256;
	bih.biClrImportant = 256;

	// create the .bmp file...
	fp = fopen(filename, "wb");

	if (fp == NULL)
		return;  // error creating the file

	hdr.bfType = 0x4d42;  // 0x42='B' 0x4d='M'

	// calculate the size of the entire .bmp file...
	hdr.bfSize = (sizeof(bitmapfileheader_t) + bih.biSize +
		bih.biClrUsed * sizeof(rgb_t) + bih.biSizeImage);

	hdr.bfReserved1 = 0;  // not used
	hdr.bfReserved2 = 0;

	// calculate the offset to the array of color indexes...
	hdr.bfOffBits = sizeof(bitmapfileheader_t) + bih.biSize +
		bih.biClrUsed * sizeof(rgb_t);

	// write the bitmapfileheader info to the .bmp file...
	if (fwrite(&hdr, sizeof(bitmapfileheader_t), 1, fp) != 1)
	{
		fclose(fp);
		return;  // error writing to file
	}

	// write the bitmapinfoheader info to the .bmp file...
	if (fwrite(&bih, sizeof(bitmapinfoheader_t), 1, fp) != 1)
	{
		fclose(fp);
		return;  // error writing to file
	}

	// write the RGB palette colors to the .bmp file...
	if (fwrite(palette, bih.biClrUsed * sizeof(rgb_t), 1, fp) != 1)
	{
		fclose(fp);
		return;  // error writing to file
	}

	// write the array of color indexes to the .bmp file...
	if (fwrite(buffer, bih.biSizeImage, 1, fp) != 1)
	{
		fclose(fp);
		return;  // error writing to file
	}

	fclose(fp);

	return;
}


void Process_WAD_Buffer(unsigned char* wad_buffer)
{
	wad_header_t* wad_header;
	wad_lumpinfo_t* wad_lump;
	mip_info_t* mip_info;
	int num_wad_lumps;
	int infotableofs;
	int index, offset;
	unsigned char* first_mip;
	unsigned char* mip_palette;
	rgb_t palette[256];
	int color;
	int color_red, color_green, color_blue;
	short int palette_size, * palette_size_ptr;
	unsigned char* buffer;
	int i, row, idx;
	int mip1_size, mip2_size, mip3_size, mip4_size;
	char filename[256];

	wad_header = (wad_header_t*)wad_buffer;

	if (strncmp(wad_header->identification, "WAD3", 4))
		return;

	num_wad_lumps = wad_header->numlumps;
	infotableofs = wad_header->infotableofs;

	for (index = 0; index < num_wad_lumps; index++)
	{
		offset = infotableofs + (index * sizeof(wad_lumpinfo_t));

		wad_lump = (wad_lumpinfo_t*)(wad_buffer + offset);

		mip_info = (mip_info_t*)(wad_buffer + wad_lump->filepos);

		printf("mip_info.name=%s\n", mip_info->name);
		printf("mip_info.width=%d\n", mip_info->width);
		printf("mip_info.height=%d\n", mip_info->height);

		first_mip = (unsigned char*)mip_info + mip_info->offsets[0];

		mip1_size = mip_info->width * mip_info->height;
		mip2_size = (mip_info->width * mip_info->height) / 4;
		mip3_size = (mip_info->width * mip_info->height) / 16;
		mip4_size = (mip_info->width * mip_info->height) / 64;

		palette_size_ptr = (short int*)((unsigned char*)mip_info + +sizeof(mip_info_t) +
			mip1_size + mip2_size + mip3_size + mip4_size);

		palette_size = *palette_size_ptr;

		mip_palette = (unsigned char*)mip_info + sizeof(mip_info_t) +
			mip1_size + mip2_size + mip3_size + mip4_size + 2;

		// check if monochrome or color image...
		color = 0;

		for (i = 0; i < 255; i++)
		{
			if ((mip_palette[i * 3] != mip_palette[i * 3 + 1]) ||
				(mip_palette[i * 3 + 1] != mip_palette[i * 3 + 2]))
			{
				color = 1;  // it's not a monochrome image
				break;
			}
		}

		color_red = mip_palette[255 * 3];
		color_green = mip_palette[255 * 3 + 1];
		color_blue = mip_palette[255 * 3 + 2];

		for (i = 0; i < 255; i++)
		{
			if (color)
			{
				palette[i].rgbRed = mip_palette[i * 3];
				palette[i].rgbGreen = mip_palette[i * 3 + 1];
				palette[i].rgbBlue = mip_palette[i * 3 + 2];
				palette[i].rgbReserved = 0;
			}
			else
			{
				palette[i].rgbRed = mip_palette[i * 3] * color_red / 256;
				palette[i].rgbGreen = mip_palette[i * 3 + 1] * color_green / 256;
				palette[i].rgbBlue = mip_palette[i * 3 + 2] * color_blue / 256;
				palette[i].rgbReserved = 0;
			}
		}

		if (color)
		{
			palette[i].rgbRed = mip_palette[255 * 3];
			palette[i].rgbGreen = mip_palette[255 * 3 + 1];
			palette[i].rgbBlue = mip_palette[255 * 3 + 2];
			palette[i].rgbReserved = 0;
		}
		else
		{
			palette[i].rgbRed = 255 * color_red / 256;
			palette[i].rgbGreen = 255 * color_green / 256;
			palette[i].rgbBlue = 255 * color_blue / 256;
			palette[i].rgbReserved = 0;
		}

		buffer = (unsigned char*)malloc(mip_info->width * mip_info->height);

		// flip the image...

		idx = mip_info->height - 1;

		for (row = 0; row < mip_info->height; row++)
		{
			memcpy(buffer + (mip_info->width * idx), first_mip + (mip_info->width * row),
				mip_info->width);

			idx--;
		}

		if (color)
		{
			sprintf(filename, "logo_c_%d.bmp", filecount_color);
			filecount_color++;
		}
		else
		{
			sprintf(filename, "logo_m_%d.bmp", filecount_mono);
			filecount_mono++;
		}

		printf("writing file %s...\n", filename);

		CreateBitmapFile(filename, mip_info->width, mip_info->height, buffer, palette);

		free(buffer);
	}
}


int main(int argc, char* argv[])
{
	FILE* fp;
	hpk_header_t hpk_header;
	hpk_lumpinfo_t* hpk_lumps;
	int num_hpk_lumps, index;
	unsigned char* hpk_buffer;
	char filename[256];

	if (argc < 2)
		strcpy(filename, "custom.hpk");  // use default filename
	else
		strcpy(filename, argv[1]);  // copy argument as filename

	filecount_mono = 1;
	filecount_color = 1;

	printf("\n");

	if ((fp = fopen(filename, "rb")) == NULL)
	{
		printf("can't open %s!\n\n", filename);

#ifdef __linux__
		printf("usage: hpk_extract path/custom.hpk\n\n");
#else
		printf("usage: hpk_extract path\\custom.hpk\n\n");
#endif

		return 0;
	}

	if (fread(&hpk_header, sizeof(hpk_header), 1, fp) != 1)
	{
		printf("can't read HPK header!\n\n");
		fclose(fp);
		return 0;
	}

	if (fseek(fp, hpk_header.infotableofs, SEEK_SET) != 0)
	{
		printf("couldn't seek to HPK lump table!\n\n");
		fclose(fp);
		return 0;
	}

	if (fread(&num_hpk_lumps, sizeof(num_hpk_lumps), 1, fp) != 1)
	{
		printf("can't read the number of HPK lumps!\n\n");
		fclose(fp);
		return 0;
	}

	hpk_lumps = (hpk_lumpinfo_t*)malloc(num_hpk_lumps * sizeof(hpk_lumpinfo_t));

	if (fread(hpk_lumps, sizeof(hpk_lumpinfo_t), num_hpk_lumps, fp) != num_hpk_lumps)
	{
		printf("can't read the HPK lumps!\n\n");
		fclose(fp);
		return 0;
	}

	for (index = num_hpk_lumps; index > 0; index--)
	{
		printf("filename=%s\n", hpk_lumps[index - 1].filename);

		// seek to the HPK lump and read it...
		if (fseek(fp, hpk_lumps[index - 1].filepos, SEEK_SET) == 0)
		{
			hpk_buffer = (unsigned char*)malloc(hpk_lumps[index - 1].hpk_lump_size);

			if (hpk_buffer != NULL)
			{
				if (fread(hpk_buffer, hpk_lumps[index - 1].hpk_lump_size, 1, fp) == 1)
				{
					Process_WAD_Buffer(hpk_buffer);
				}

				free(hpk_buffer);
			}
		}

		printf("\n");
	}

	free(hpk_lumps);

	printf("created %d monochrome bitmaps and %d color bitmaps\n\n",
		filecount_mono - 1, filecount_color - 1);

	fclose(fp);

	return 1;
}
