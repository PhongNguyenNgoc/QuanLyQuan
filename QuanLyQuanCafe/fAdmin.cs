using QuanLyQuanCafe.DAO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyQuanCafe
{
    public partial class fAdmin : Form
    {
        public fAdmin()
        {
            InitializeComponent();
            Load();

        }
        #region Method
        void Load()
        {
            LoadDateTimePickerBill();
            LoadListViewByDate(dtpkFromDate.Value, dtpkToDate.Value);
            LoadListFood();
        }
        void LoadDateTimePickerBill()
        {
            DateTime today = DateTime.Now;
            dtpkFromDate.Value = new DateTime(today.Year, today.Month, 1);
            dtpkToDate.Value = dtpkFromDate.Value.AddMonths(1).AddDays(-1);
        }
        void LoadListViewByDate(DateTime checkIn, DateTime checkOut)
        {
            dtgvBill.DataSource = BillDAO.Instance.GetBillListBydate(checkIn, checkOut);
        }

        void LoadListFood()
        {
            dtgvFood.DataSource = FoodDAO.Instance.GetListFood();
        }
        #endregion


        #region Event
        private void btnViewBill_Click(object sender, EventArgs e)
        {
            LoadListViewByDate(dtpkFromDate.Value, dtpkToDate.Value);
        }
        private void btnShowFood_Click(object sender, EventArgs e)
        {
            LoadListFood();
        }
        #endregion


    }
}
