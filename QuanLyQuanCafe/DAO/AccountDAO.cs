using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class AccountDAO
    {
        //Patern Singleton
        private static AccountDAO instance;

        public static AccountDAO Instance
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; }
            private set { instance = value; }
        }
        private AccountDAO() { }

        //================
        public bool Login(string username, string password) 
        {
            string query = "USP_Login @userName , @passWord";

            DataTable result = DataProvider.Instance.ExcuteQuery(query,new Object[] {username , password});

            return result.Rows.Count>0;
        }
    }
}
