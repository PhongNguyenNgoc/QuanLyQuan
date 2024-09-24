using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DTO
{
    public class Account
    {
        public Account(string userName, string displayName, int type, string password = null)            
        {
            this.userName= userName;
            this.displayName= displayName;
            this.type = type;
            this.password= password;
            
        }

        public Account(DataRow row)
        {
            this.userName = row["userName"].ToString();
            this.displayName = row["displayName"].ToString();
            this.type = (int)row["type"];
            this.password = row["passWord"].ToString();
        }

        private string userName;
        private string displayName;
        private string password;
        private int type;

        public string UserName
        {
            get
            {
                return userName;
            }

            set
            {
                userName = value;
            }
        }

        public string DisplayName
        {
            get
            {
                return displayName;
            }

            set
            {
                displayName = value;
            }
        }

        public string Password
        {
            get
            {
                return password;
            }

            set
            {
                password = value;
            }
        }

        public int Type
        {
            get
            {
                return type;
            }

            set
            {
                type = value;
            }
        }
    }
}
