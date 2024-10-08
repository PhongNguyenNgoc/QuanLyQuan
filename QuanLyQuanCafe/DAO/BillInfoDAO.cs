﻿using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class BillInfoDAO
    {
        //Patern Singleton
        private static BillInfoDAO instance;

        public static BillInfoDAO Instance
        {
            get { if (instance == null) instance = new BillInfoDAO(); return BillInfoDAO.instance; }
            private set { BillInfoDAO.instance = value; }
        }
        private BillInfoDAO() { }
        //===================
        public List<BillInfo> GetListBillInfo(int id) 
        {
            List<BillInfo> listBillInfo=  new List<BillInfo>();
            DataTable data = DataProvider.Instance.ExcuteQuery("SELECT * FROM dbo.BillInfo WHERE idBill=" + id);

            foreach (DataRow item in data.Rows) 
            {
                BillInfo info = new BillInfo(item);
                listBillInfo.Add(info);
            }
            return listBillInfo;
        }
        public void insertBillInfo(int idBill,int idFood, int count)
        {
            DataProvider.Instance.ExcuteNonQuery("EXEC USP_InsertBillInfo @idBill , @idFood , @count", new Object[] { idBill , idFood , count });
        }
        public void DeleteBillInfoByID(int id)
        {
            DataProvider.Instance.ExcuteQuery("DELETE dbo.BillInfo WHERE idFood="+id);

        }
    }
}
