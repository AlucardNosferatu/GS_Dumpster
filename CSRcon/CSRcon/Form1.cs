using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace CSRcon
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {   
        }

        private void btnSend_Click(object sender, EventArgs e)
        {
            CSRcon cs = new CSRcon();
            this.txtResponse.Text = "";
            this.txtResponse.Text = cs.sendRCON(this.txtServerIP.Text, int.Parse(this.txtServerPort.Text), this.txtPassword.Text, this.txtCommand.Text).Replace("\n","\r\n");
        }
    }
}