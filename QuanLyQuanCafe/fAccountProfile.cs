using QuanLyQuanCafe.DAO;
using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyQuanCafe
{
    public partial class fAccountProfile : Form
    {
        private Account loginAccount;

        public Account LoginAccount
        {
            get
            {
                return loginAccount;
            }

            set
            {
                loginAccount = value;
                ChangeAccount(loginAccount);
            }
        }

        public fAccountProfile(Account acc)
        {
            InitializeComponent();

            LoginAccount = acc;
        }
        public void ChangeAccount(Account acc)
        {
            txbUserName.Text = LoginAccount.UserName;
            txbDisPlayname.Text = LoginAccount.DisplayName;
        }
        void UpdateAccount()
        {
            string displayName = txbDisPlayname.Text;
            string password = txbPassWord.Text;
            string newpass = txbNewPass.Text;
            string reenterpass = txbReEnterPass.Text;
            string username = txbUserName.Text;

            if (!newpass.Equals(reenterpass))
            {
                MessageBox.Show("Vui lòng nhập lại mật khẩu cho khớp với mật khẩu mới", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                if (AccountDAO.Instance.UpdateAccount(username, displayName, password, newpass))
                {
                    MessageBox.Show("Cập nhật thông tin thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Sai mật khẩu", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    
        private void btnUpdate_Click(object sender, EventArgs e)
        {
            UpdateAccount();
        }
    }
}
