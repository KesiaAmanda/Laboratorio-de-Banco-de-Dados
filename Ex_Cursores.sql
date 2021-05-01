USE master
GO
DROP DATABASE Cursores
GO
CREATE DATABASE Cursores
GO
USE Cursores

GO
CREATE TABLE Filiais(
idFilial		INT PRIMARY KEY,
Logradouro		VARCHAR(100) NOT NULL,
Numero			INT NOT NULL
)

GO

INSERT INTO Filiais VALUES
(1, 'R. A', 250),
(2, 'R. B', 500),
(3, 'R. C', 125)
GO

CREATE TABLE Cliente(
idCliente		INT PRIMARY KEY,
Nome			VARCHAR(100) NOT NULL,
Filial			INT FOREIGN KEY REFERENCES Filiais (idFilial) NOT NULL,
Gasto_Filial	DECIMAL(7,2) NOT NULL
)
GO

INSERT INTO Cliente VALUES
(1001, 'Cliente1', 1, 6404.00),
(1002, 'Cliente2', 1, 5652.00),
(1003, 'Cliente3', 3, 1800.00),
(1004, 'Cliente4', 2, 3536.00),
(1005, 'Cliente5', 2, 8110.00),
(1006, 'Cliente6', 2, 5256.00),
(1007, 'Cliente7', 2, 6879.00),
(1008, 'Cliente8', 2, 7092.00),
(1009, 'Cliente9', 3, 7976.00),
(1010, 'Cliente10', 3, 4192.00),
(1011, 'Cliente11', 3, 8278.00),
(1012, 'Cliente12', 1, 8913.00)

GO

CREATE FUNCTION fn_cli_fil_3() 
RETURNS @table TABLE (
idCliente			INT,
nomeCliente			VARCHAR(100),
Gasto_Filial_3		DECIMAL(7,2),
Multa_Filiais		DECIMAL(7,2)
)
AS
BEGIN
	DECLARE @idCliente			INT,
			@nomeCliente			VARCHAR(100),
			@Gasto_Filial_3		DECIMAL(7,2),
			@Multa_Filiais		DECIMAL(7,2)

	DECLARE c CURSOR FOR SELECT idCliente, Nome, Gasto_Filial FROM Cliente WHERE Filial = 3

	OPEN c
	FETCH NEXT FROM c INTO @idCliente, @nomeCliente, @Gasto_Filial_3

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		IF (@Gasto_Filial_3 <= 3000.00)
		BEGIN
			SET @Multa_Filiais = @Gasto_Filial_3*0.15
		END
		ELSE IF (@Gasto_Filial_3 <= 6000.00)
		BEGIN
			SET @Multa_Filiais = @Gasto_Filial_3-((@Gasto_Filial_3*0.75)-100)
		END
		ELSE
		BEGIN
			SET @Multa_Filiais = @Gasto_Filial_3*0.35
		END

		INSERT INTO @table VALUES
		(@idCliente, @nomeCliente, @Gasto_Filial_3, @Multa_Filiais)
 
		FETCH NEXT FROM c INTO @idCliente, @nomeCliente, @Gasto_Filial_3
	END

	CLOSE c
	DEALLOCATE c

	RETURN
END

GO

SELECT * FROM fn_cli_fil_3() 