using QuanLyQuanCafe.DAO;
using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Menu = QuanLyQuanCafe.DTO.Menu;

namespace QuanLyQuanCafe
{
    public partial class fTableManager : Form
    {
        public fTableManager()
        {
            InitializeComponent();
            LoadTable();
            LoadCategory();
        }
        #region Method

        void LoadCategory()
        {
            List<Category> listCategory = CategoryDAO.Instance.GetListCategory();
            cbCategory.DataSource= listCategory;
            cbCategory.DisplayMember = "Name";
        }

        void LoadFoodListByCategoryID(int id)
        {
            List<Food> listFood = FoodDAO.Instance.GetListCategoryID(id);
            cbFood.DataSource= listFood;
            cbFood.DisplayMember = "Name";
        }
        void LoadTable()
        {
           flpTable.Controls.Clear();
           List<Table> tableList= TableDAO.Instance.LoadTableList();
            foreach (Table item in tableList) 
            {
                Button btn = new Button() { Width = TableDAO.TableWidth, Height= TableDAO.TableHeight };
                btn.Text = item.Name + Environment.NewLine+item.Status;

                btn.Click += Btn_Click;
                btn.Tag= item;

                switch (item.Status)
                {
                    case "Trống":
                        btn.BackColor = Color.Lime;
                        break;

                    default:
                        btn.BackColor = Color.Pink;
                        break;

                }
                flpTable.Controls.Add(btn);
                
            }
        }

        void ShowBill(int id)
        {
            lsvBill.Items.Clear();
            List<QuanLyQuanCafe.DTO.Menu> listBillInfo = MenuDAO.Instance.GetListMenuByTable(id);

            float totalPrice =0;
            foreach (QuanLyQuanCafe.DTO.Menu item in listBillInfo)
            {
                ListViewItem lsvItem = new ListViewItem(item.FoodName.ToString());
                lsvItem.SubItems.Add(item.Count.ToString());
                lsvItem.SubItems.Add(item.Price.ToString());
                lsvItem.SubItems.Add(item.TotalPrice.ToString());

                totalPrice += item.TotalPrice;
                lsvBill.Items.Add(lsvItem);
            }
            //CultureInfo culture= new CultureInfo("vi-VN");
            txbTotalPrice.Text = totalPrice.ToString();
          
        }

        #endregion

        #region Event
        private void Btn_Click(object sender, EventArgs e)
        {
            int tableID= ((sender as Button).Tag as Table).ID;
            lsvBill.Tag=(sender as Button).Tag;
            ShowBill(tableID);
        }
        private void đăngXuấtToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void thôngKtinTàiKhoảnToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAccountProfile f = new fAccountProfile();
            f.ShowDialog();
        }

        private void adminToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAdmin fAdmin = new fAdmin();
            fAdmin.ShowDialog();
        }

        private void cbCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = 0;
            ComboBox cb = sender as ComboBox;

            if(cb.SelectedItem == null)
            {
                return;
            }
            Category selected = cb.SelectedItem as Category;
            id= selected.ID;
            LoadFoodListByCategoryID(id);
        }

        private void btnAddFood_Click(object sender, EventArgs e)
        {
            Table table= lsvBill.Tag as Table;
            int idBill = BillDAO.Instance.getUncheckBillIDByTableID(table.ID);
            int FoodID = (cbFood.SelectedItem as Food).ID;
            int count= (int)nmFoodCount.Value;

            //TH1: Chua co bill nao va  tao bill moi
            if (idBill == -1)
            {
                BillDAO.Instance.insertBill(table.ID);
                BillInfoDAO.Instance.insertBillInfo(BillDAO.Instance.getMaxIDBill(), FoodID, count);
            }
            //TH2: them bill da ton tai
            else 
            {
                BillInfoDAO.Instance.insertBillInfo(idBill, FoodID, count);
            }
            ShowBill(table.ID);
            LoadTable();
        }
        private void btnCheckOut_Click(object sender, EventArgs e)
        {
            Table table = lsvBill.Tag as Table;
            int idBill =BillDAO.Instance.getUncheckBillIDByTableID(table.ID);
            int discount=(int)nmDisCount.Value;
            float totalPrice = float.Parse(txbTotalPrice.Text);
            float finalTotalPrice = totalPrice - (totalPrice * discount) / 100;
            if(idBill != -1)
            {
                if (MessageBox.Show(string.Format("Bàn {0} đã thực hiện thanh toán? \n với giá tiền trả đã giảm {1}% là {2}", table.Name,discount,finalTotalPrice), "Thông báo", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) == System.Windows.Forms.DialogResult.OK) 
                { 
                    BillDAO.Instance.checkOut(idBill,discount);
                    ShowBill(table.ID);
                }
            }
            LoadTable();

        }

        #endregion


    }
}
