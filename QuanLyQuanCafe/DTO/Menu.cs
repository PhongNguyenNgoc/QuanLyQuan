using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DTO
{
     public class Menu
    {
        public Menu(string foodname, int count, float price,float totalPrice=0)
        {
            this.foodName = foodname;
            this.count = count;
            this.price = price;
            this.totalPrice = totalPrice;
        }

        public Menu(DataRow row)
        {
            this.foodName = row["name"].ToString();
            this.count = (int)row["count"] ;
            this.price = (float)Convert.ToDouble(row["price"].ToString());
            this.totalPrice = (float)Convert.ToDouble(row["totalPrice"].ToString());
        }
        private string foodName;
        private int count;
        private float price;
        private float totalPrice;

        public string FoodName
        {
            get
            {
                return foodName;
            }

            set
            {
                foodName = value;
            }
        }

        public int Count
        {
            get
            {
                return count;
            }

            set
            {
                count = value;
            }
        }

        public float Price
        {
            get
            {
                return price;
            }

            set
            {
                price = value;
            }
        }

        public float TotalPrice
        {
            get
            {
                return totalPrice;
            }

            set
            {
                totalPrice = value;
            }
        }
    }
}
