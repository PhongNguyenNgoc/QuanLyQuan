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
	status INT NOT NULL DEFAULT 0, -- 1: đã thanh toán && 0: chưa thanh toán
	discount INT,
    totalPrice FLOAT,
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
          status,

        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          1 , -- idTable - int
          0  -- status - int
        ),(GETDATE(),NULL,2,0),(GETDATE(),GETDATE(),2,1)

--=====================Them Bill Stored Procedure=============
go
CREATE PROC USP_InsertBill
@idTable INT 
AS
BEGIN
	INSERT dbo.Bill
	        ( DateCheckIn ,
	          DateCheckOut ,
	          idTable ,
	          status,
			  discount
	        )
	VALUES  ( GETDATE() , -- DateCheckIn - date
	          null , -- DateCheckOut - date
	          @idTable , -- idTable - int
	          0 ,
			  0 -- status - int
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
--===!!!!!!!!!!!!========tao trigger cho viec them sua bang Update Bill Info========
CREATE TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfo FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = idBill FROM Inserted

	DECLARE @idTable INT 
	SELECT @idTable = idTable FROM dbo.Bill where id = @idBill AND status = 0

	DECLARE @count INT
	SELECT COUNT(*) FROM dbo.BillInfo WHERE idBill=@idBill 

	IF (@count>0)
		UPDATE dbo.TableFood SET status = N'Trống'WHERE id=@idTable
	ELSE 
		UPDATE dbo.TableFood SET status = N'Có người'WHERE id=@idTable
END
GO

--=========================================================
GO
CREATE TRIGGER UTG_UpdateBill
ON dbo.Bill FOR UPDATE
AS 
BEGIN
	DECLARE @idBill INT
	SELECT @idBill=id FROM Inserted

	DECLARE @idTable INT
	SELECT @idTable= idTable FROM  dbo.Bill WHERE id=@idBill

	DECLARE @count INT
	SELECT @count=COUNT(*) FROM dbo.Bill WHERE idTable=@idTable AND status = 0

	IF (@count = 0)
		UPDATE dbo.TableFood SET status=N'Trống' WHERE id=@idTable
END

--================Tao proc Switchtable==================================
ALTER PROC USP_SwitchTable
@idTable1 int , @idTable2 int
AS
BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT 

	DECLARE @isFirstTableEmppty INT = 1
	DECLARE @isSencondTableEmppty INT = 1

	DECLARE @isIsFirstTableEmpty INT = 1
	DECLARE @isIsSecondTableEmpty INT = 1

	SELECT @idSecondBill = id FROM dbo.Bill WHERE idTable=@idTable2 AND status = 0
	SELECT @idFirstBill= id FROM dbo.Bill WHERE idTable=@idTable1 AND status = 0

	IF(@idFirstBill IS NULL)
		BEGIN
			INSERT INTO dbo.Bill
			        ( DateCheckIn ,
			          DateCheckOut ,
			          idTable ,
			          status ,
			          discount
			        )
			VALUES  ( GETDATE() , -- DateCheckIn - date
			          NULL , -- DateCheckOut - date
			          @idTable1 , -- idTable - int
			          0 , -- status - int
			          0  -- discount - int
			        )
			SELECT @idFirstBill=MAX(id) FROM dbo.Bill WHERE idTable=@idTable1 AND status = 0

			--set @isFirstTableEmppty = 1

		END

		SELECT @isIsFirstTableEmpty = COUNT(*) FROM dbo.BillInfo WHERE idBill=@idFirstBill


		IF(@idSecondBill IS NULL)
			BEGIN
				INSERT INTO dbo.Bill
			        ( DateCheckIn ,
			          DateCheckOut ,
			          idTable ,
			          status ,
			          discount
			        )
				VALUES  ( GETDATE() , -- DateCheckIn - date
			          NULL , -- DateCheckOut - date
			          @idTable2 , -- idTable - int
			          0 , -- status - int
			          0  -- discount - int
			        )
			SELECT @idSecondBill=MAX(id) FROM dbo.Bill WHERE idTable=@idTable2 AND status = 0

			SET @isSencondTableEmppty = 1 


			END
			SELECT @isIsSecondTableEmpty = COUNT(*) FROM dbo.BillInfo WHERE idBill=@idSecondBill

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSecondBill
	UPDATE dbo.BillInfo SET idBill=@idSecondBill WHERE idBill = @idFirstBill
	UPDATE dbo.BillInfo SET idBill=@idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	DROP TABLE IDBillInfoTable

	IF (@isIsFirstTableEmpty =0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id=@idTable2

	IF (@isIsSecondTableEmpty =0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id=@idTable1

END
GO
--=================tao proc xem tat ca bill============
CREATE PROC USP_GetListBillByDate
@checkIn DATE, @checkOut DATE
AS
BEGIN
     SELECT t.name AS [Tên bàn], DateCheckIn AS [Ngày vào], DateCheckOut as [Ngày thanh toán] , discount AS [Giảm giá], b.totalPrice AS [Tổng hóa đơn]
	FROM dbo.Bill AS b, dbo.TableFood AS t
	WHERE DateCheckIn >= '20240923' AND DateCheckOut >='20240923'AND b.status = 1 AND t.id=b.idTable

END
GO
--tao proc  cap nhat user=================
CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE UserName=@userName AND PassWord=@password
	IF (@isRightPass=1)
		BEGIN
			IF (@newPassword IS NULL OR @newPassword='')
				BEGIN
					UPDATE dbo.Account SET	DisplayName=@displayName WHERE UserName=@userName
				END
			ELSE
				BEGIN
				    UPDATE dbo.Account SET	DisplayName=@displayName , PassWord=@newPassword WHERE UserName=@userName
				END	
				
		END
	
	
END
go
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

UPDATE dbo.Bill SET status=1 WHERE id=1

DELETE dbo.BillInfo
DELETE dbo.Bill

UPDATE dbo.Bill SET discount = 0

DECLARE @idBillTest int = 41
SELECT * FROM dbo.BillInfo WHERE idBill=@idBillTest



UPDATE dbo.TableFood SET status =N'Trống'

SELECT * FROM dbo.BillInfo

ALTER TABLE dbo.Bill ADD totalPrice FLOAT


SELECT *
FROM dbo.Bill

EXEC dbo.USP_GetListBillByDate @checkIn = '20240923', -- date
    @checkOut = '20240923' -- date

 SELECT t.name, DateCheckIn, DateCheckOut , discount, b.totalPrice
	FROM dbo.Bill AS b, dbo.TableFood AS t
	WHERE DateCheckIn >= '20240923' AND DateCheckOut >='20240923'AND b.status = 1 AND t.id=b.idTable


SELECT * FROM dbo.BillInfo
SELECT * FROM dbo.Account WHERE UserName='admin'

SELECT * FROM dbo.Food
 SELECT COUNT(*) FROM dbo.Account WHERE UserName='nv' AND PassWord='nv'

 INSERT INTO dbo.Food( name, idCategory, price ) VALUES  ( N'',0, 0.0 )
 UPDATE dbo.Food SET name=N'', idCategory = 5, price = 0 WHERE id = 5

 SELECT * FROM dbo.BillInfo
 DELETE dbo.BillInfo WHERE idFood=2
 
 SELECT * FROM dbo.Food 
