CREATE DATABASE QuanLyQuanCafe
GO

USE QuanLyQuanCafe
GO

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Bàn chưa có tên',
	status NVARCHAR(100) NOT NULL DEFAULT N'Trống'	-- Trống || Có người
)
GO

CREATE TABLE Account
(
	UserName NVARCHAR(100) PRIMARY KEY,	
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Chua co ten',
	PassWord NVARCHAR(1000) NOT NULL DEFAULT 0,
	Type INT NOT NULL  DEFAULT 0 -- 1: admin && 0: staff
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên'
)
GO

CREATE TABLE Food
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên',
	idCategory INT NOT NULL,
	price FLOAT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn DATE NOT NULL DEFAULT GETDATE(),
	DateCheckOut DATE,
	idTable INT NOT NULL,
	status INT NOT NULL DEFAULT 0 -- 1: đã thanh toán && 0: chưa thanh toán
	
	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)
)
GO
--=========================Them tai khoan======================================
INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'admin' , -- UserName - nvarchar(100)
          N'admin' , -- DisplayName - nvarchar(100)
          N'admin' , -- PassWord - nvarchar(1000)
          1  -- Type - int
        )

INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'nv' , -- UserName - nvarchar(100)
          N'nv' , -- DisplayName - nvarchar(100)
          N'nv' , -- PassWord - nvarchar(1000)
          0  -- Type - int
        )

GO
--**************Tao Stored Procedure cho dang nhap****************************
CREATE PROC USP_Login
@userName NVARCHAR(100), @passWord NvarCHAR(100)
AS
	BEGIN
		SELECT * FROM dbo.Account WHERE UserName=@userName AND PassWord=@passWord
	END
GO

EXEC USP_Login @userName='admin', @passWord='admin'

-- *********************Tao ban*****************************

DECLARE @i INT = 0
WHILE @i <=10
BEGIN
	INSERT dbo.TableFood ( name ) VALUES  ( N'Bàn '+ CAST(@i AS NVARCHAR(100)))
	SET @i=@i+1	          
END


--************************Tao Stored Procedure cho ban****************************
GO

CREATE PROC USP_TableList
AS SELECT * FROM dbo.TableFood 
GO

EXEC dbo.USP_TableList
--*********************Tao gia tri cho FC***********************
SELECT * FROM dbo.FoodCategory

INSERT INTO dbo.FoodCategory
        ( name )
VALUES  ( N'Hải sản'  -- name - nvarchar(100)
          ),(N'Nông sản'),(N'Lâm sản'),(N'Sản sản'),(N'Nước')
--***************Them mon an****************
SELECT * FROM dbo.Food
INSERT INTO dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Mực một nắng nướng sa tế', -- name - nvarchar(100)
          1, -- idCategory - int
          120000  -- price - float
          ),(N'Nghêu hấp sẳ',1,50000),(N'Dú dê nướng sữa',2,50000),(N'Heo rừng nướng muối ớt',3,50000),(N'Cơm chiên thập cẩm',4,50000),(N'7UP',5,15000),(N'Cafe',5,10000);

--*******************Them bill *******************

SELECT * FROM dbo.Bill
INSERT INTO dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          1 , -- idTable - int
          0  -- status - int
        ),(GETDATE(),NULL,2,0),(GETDATE(),GETDATE(),2,1)

--=====================Them Bill Stored Procedure=============
CREATE PROC USP_InsertBill
@idTable INT 
AS
BEGIN
	INSERT dbo.Bill
	        ( DateCheckIn ,
	          DateCheckOut ,
	          idTable ,
	          status
	        )
	VALUES  ( GETDATE() , -- DateCheckIn - date
	          null , -- DateCheckOut - date
	          @idTable , -- idTable - int
	          0  -- status - int
	        )
END	
GO

--========================Them bill info
SELECT * FROM dbo.BillInfo
INSERT dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          1, -- idFood - int
          2  -- count - int
          ),(1,3,4),(1,5,1),(2,6,2),(3,5,2);
--=================Tao bill info Store Procedure===
GO

CREATE PROC USP_InsertBillInfo
@idBill int , @idFood int ,@count int 
AS
BEGIN
	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfo= id,@foodCount= count FROM dbo.BillInfo WHERE @idBill=idBill AND @idFood=idFood

	IF (@isExitsBillInfo > 0)
		BEGIN
			DECLARE @newCount INT = @foodCount + @count
			IF (@newCount > 0)
				UPDATE dbo.BillInfo SET count = @foodCount + @count WHERE idFood=@idFood
			ELSE
				DELETE dbo.BillInfo WHERE idBill=@idBill AND idFood=@idFood
		END
	ELSE
		BEGIN
			INSERT dbo.BillInfo
	        ( idBill, idFood, count )
			VALUES  ( @idBill, -- idBill - int
	          @idFood, -- idFood - int
	          @count  -- count - int
	          )
		END		
END
GO


--======================DEBUG ZONE========================
UPDATE dbo.TableFood SET status = N'Có người' WHERE id=7
SELECT * FROM Food

SELECT * FROM dbo.Bill
SELECT * FROM dbo.BillInfo
SELECT* FROM dbo.Food
SELECT * FROM dbo.FoodCategory

DELETE  dbo.Food

SELECT * FROM dbo.BillInfo WHERE idBill=3
 
 SELECT * FROM dbo.Bill WHERE idTable=2 AND status = 0

 SELECT f.name,bi.count,f.price,f.price * bi.count AS totalPrice
 FROM dbo.BillInfo AS bi,dbo.Bill AS b,dbo.Food AS f 
 WHERE bi.idBill=b.id AND bi.idFood =f.id AND b.idTable=2

UPDATE dbo.Bill SET idTable=3 WHERE id=3

SELECT * FROM dbo.Food WHERE idCategory=1

SELECT MAX(id) FROM dbo.Bill