﻿using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class MenuDAO
    {
        //==================
        private static MenuDAO instance;

        public static MenuDAO Instance
        {
            get
            {
                if (instance == null) 
                    instance = new MenuDAO();
                return instance;
            }

            private set
            {
                instance = value;
            }
        }
        //===================
        public List<Menu> GetListMenuByTable(int id) 
        {
            List<Menu> listMenu = new List<Menu>();

            string q = " SELECT f.name,bi.count,f.price,f.price * bi.count AS totalPrice\r\n FROM dbo.BillInfo AS bi,dbo.Bill AS b,dbo.Food AS f \r\n WHERE bi.idBill=b.id AND bi.idFood =f.id AND b.idTable="+id+" AND status=0";
            DataTable data = DataProvider.Instance.ExcuteQuery(q);

            foreach (DataRow item in data.Rows)
            { 
                Menu menu = new Menu(item);
                listMenu.Add(menu);
            }

            return listMenu;
        }
    }
}
