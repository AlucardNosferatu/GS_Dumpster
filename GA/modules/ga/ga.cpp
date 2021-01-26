#include <string>
#include <math.h>
#include "ga.hpp"
#include "amxxmodule.h"

using namespace std;

//GATask* gTask;
GATaskIndex* gTask;
bool status;
bool eval;
int err_index;

static cell AMX_NATIVE_CALL init_task(AMX* amx, cell* params)
{
	const int population = params[1];
	gTask = new GATaskIndex(population);
	status = true;
	eval = false;
	return 1;
}

static cell AMX_NATIVE_CALL get_individual(AMX* amx, cell* params)
{
	if (status)
	{
		cell Index = params[1];
		cell* IndArray = MF_GetAmxAddr(amx, params[2]);
		const cell IndArray_size = params[3];
		Test Ind = gTask->GetInd(Index);
		if (IndArray_size >= 4)
		{
			IndArray[0] = amx_ftoc(static_cast<float>(Ind.a));
			IndArray[1] = amx_ftoc(static_cast<float>(Ind.a));
			IndArray[2] = amx_ftoc(static_cast<float>(Ind.a));
			IndArray[3] = amx_ftoc(static_cast<float>(Ind.a));
		}
	}
	return 1;
}

static cell AMX_NATIVE_CALL evaluate_gen(AMX* amx, cell* params)
{
	if (status)
	{
		const cell* scores_amx = MF_GetAmxAddr(amx, params[3]);
		const cell scores_size = params[4];
		double* scores = new double[scores_size];
		for (int i = 0; i < scores_size; i++)
		{
			const float element = amx_ctof(scores_amx[i]);
			scores[i] = static_cast<double>(element);
			if (isfinite<double>(scores[i]) == 0)
			{
				err_index = i;
			}
		}
		gTask->Eva(scores);

		eval = true;
		const Test BestForNow = gTask->GetBest();
		cell* array = MF_GetAmxAddr(amx, params[1]);
		const cell array_size = params[2];
		if (array_size >= 4)
		{
			array[0] = amx_ftoc(static_cast<float>(BestForNow.a));
			array[1] = amx_ftoc(static_cast<float>(BestForNow.a));
			array[2] = amx_ftoc(static_cast<float>(BestForNow.a));
			array[3] = amx_ftoc(static_cast<float>(BestForNow.a));
		}
	}
	return 1;
}

static cell AMX_NATIVE_CALL update_gen(AMX* amx, cell* params)
{
	if (status)
	{
		gTask->Update();
		eval = false;
	}
	return 1;
}

AMX_NATIVE_INFO natives[] = {
	{ "init_task", init_task },
	{ "get_individual", get_individual },
	{ "evaluate_gen", evaluate_gen },
	{ "update_gen", update_gen },
	{ NULL, NULL }
};

void OnAmxxAttach() {
	status = false;
	eval = false;
	MF_AddNatives(natives);
}
