using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DTO
{
    public class Bill
    {
        public Bill(int id, DateTime? dateCheckin, DateTime? dateCheckOut,int status)
        {
            this.ID = id;
            this.DateCheckIn = dateCheckin;
            this.DateCheckOut = dateCheckOut;
            this.Status = status;
        }
        private int status;
        private DateTime? dateCheckOut;
        private DateTime? dateCheckIn;
        private int iD;
        
        public Bill(DataRow row)
        {
            this.ID = (int)row["id"];
            this.DateCheckIn = (DateTime?)row["DateCheckIn"];

            var dateCheckOutTemp = row["DateCheckOut"];
            if (dateCheckOutTemp.ToString() != "")
            {
                this.DateCheckOut=(DateTime?)dateCheckOutTemp;
            }

            this.Status = (int)row["status"];
        }
        public int ID
        {
            get
            {
                return iD;
            }

            set
            {
                iD = value;
            }
        }

        public DateTime? DateCheckIn
        {
            get
            {
                return dateCheckIn;
            }

            set
            {
                dateCheckIn = value;
            }
        }

        public DateTime? DateCheckOut
        {
            get
            {
                return dateCheckOut;
            }

            set
            {
                dateCheckOut = value;
            }
        }

        public int Status
        {
            get
            {
                return status;
            }

            set
            {
                status = value;
            }
        }
    }
}
