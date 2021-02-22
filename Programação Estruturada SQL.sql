/*Fazer um algoritmo que leia 3 valores e retorne se os valores formam um triângulo e se ele é
isóceles, escaleno ou equilátero.
Condições para formar um triângulo
	Nenhum valor pode ser = 0
	Um lado não pode ser maior que a soma dos outros 2.
*/
DECLARE @valor1 INT,
		@valor2 INT,
		@valor3 INT

SET @valor1 = 3
SET @valor2 = 3
SET @valor3 = 6

IF ((@valor1 + @valor2) >= @valor3 AND (@valor1 + @valor3) >= @valor2 AND (@valor2 + @valor3) >= @valor1
	AND @valor1 != 0 AND @valor2 != 0 AND @valor3 !=0)
BEGIN
	IF (@valor1 = @valor2 AND @valor1 = @valor3)
	BEGIN 
		PRINT 'equilatero'
	END
	ELSE IF (@valor1 = @valor2 OR @valor1 = @valor3 OR @valor2 = @valor3)
	BEGIN
		PRINT 'isóceles'
	END
	ELSE
	BEGIN
		PRINT 'escaleno'
	END
END
ELSE
BEGIN
	PRINT 'ENTRADA INVALIDA'
END

-- Fazer um algoritmo que, dado 1 número, mostre se é múltiplo de 2,3,5 ou nenhum deles

DECLARE @valor INT
SET @valor = 250

PRINT @valor

IF (@valor%2 = 0)
BEGIN
	PRINT 'É MULTIPLO DE 2'
END
IF (@valor%3 = 0)
BEGIN
	PRINT  'É MULTIPLO DE 3'
END
IF (@valor%5 = 0)
BEGIN
	PRINT 'É MULTIPLO DE 5'
END

-- Fazer um algoritmo que, dados 3 números, mostre o maior e o menor
DECLARE @valor1 INT,
		@valor2 INT,
		@valor3 INT,
		@maior INT,
		@menor INT
SET @valor1 = 10
SET @valor2 = 20
SET @valor3 = 15

SET @maior = @valor1
IF (@maior > @valor2 AND @maior > @valor3)
BEGIN
	SET @maior = @valor1
END
ELSE
SET @maior = @valor2
IF (@maior < @valor3)
BEGIN
	SET @maior = @valor3
END

SET @menor = @valor1
IF (@menor < @valor2 AND @menor < @valor3)
BEGIN
	SET @menor = @valor1
END
ELSE
SET @menor = @valor2
IF (@menor > @valor3)
BEGIN
	SET @menor = @valor3
END

PRINT CAST(@maior AS VARCHAR(10))+' É O MAIOR VALOR E '+ CAST(@menor AS VARCHAR(10))+ ' É O MENOR VALOR'

-- Fazer um algoritmo que calcule os 15 primeiros termos da série de Fibonacci e a soma dos 15 primeiros termos

DECLARE @cont INT,
		@anterior1 INT,
		@anterior2 INT,
		@prox INT
SET @cont = 1
SET @anterior1 = 1
SET @anterior2 = 1

WHILE (@cont <= 15)
BEGIN
	SET @prox = @anterior1 + @anterior2
	PRINT @prox
	SET @anterior2 = @anterior1
	SET @anterior1 = @prox
	SET @cont = @cont + 1
END

-- Fazer um algoritmo que separa uma frase, imprimindo todas as letras em maiúsculo e, depois imprimindo todas em minúsculo

--SUBTRING('BANCO DE DADOS',1,5)
DECLARE @frase VARCHAR(100)
DECLARE	@cont INT

SET @cont = 1
SET @frase = 'oi tudo bem'

WHILE(@cont <= LEN(@frase))
BEGIN
	PRINT UPPER(SUBSTRING(@frase,@cont,1))
	SET @cont = @cont + 1
END

SET @cont = 1
WHILE(@cont <= LEN(@frase))
BEGIN
	PRINT LOWER(SUBSTRING(@frase,@cont,1))
	SET @cont = @cont + 1
END

-- Fazer um algoritmo que inverta uma palavra

DECLARE @frase VARCHAR(50),
		@cont INT,
		@saida VARCHAR(50)

SET @frase = 'OI TUDO BOM BOM BOM'
SET @cont = 0
SET @saida = ''

WHILE (@cont <= LEN(@frase))
BEGIN
	SET @saida = @saida + SUBSTRING(@frase, (LEN(@frase) - @cont), 1)
	SET @cont = @cont + 1
END
PRINT @saida


-- Fazer um algoritmo que verifica, dada uma palavra, se é, ou não, palíndromo

DECLARE @frase VARCHAR(100),
		@cond BIT,
		@cont INT

SET @cont = 1
SET @cond = 1
SET @frase = 'omissíssimo'

WHILE(@cont <= FLOOR(LEN(@frase)/2))
BEGIN
	IF (SUBSTRING(@frase, @cont, 1) != SUBSTRING(@frase, LEN(@frase)-(@cont-1), 1))
	BEGIN
		SET	@cond = 0
	END
	SET @cont = @cont + 1
END

IF (@cond = 0)
BEGIN
	PRINT 'NÃO É PALINDROMO'
END
ELSE
BEGIN
	PRINT 'É PALINDROMO'
END

-- Fazer um algoritmo que, dado um CPF diga se é válido

DECLARE @cpf VARCHAR(11),
		@valido BIT,
		@cont INT,
		@prime INT,
		@res INT,
		@aux INT

SET @cpf = '22233344455'
SET @valido = 1
SET @aux = 1

WHILE(@valido = 1 AND @aux <= 2)
BEGIN

	SET @cont = 1
	SET @res = 0

	WHILE (@cont <= 8+@aux)
	BEGIN
	SET	@res = @res + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * ((10+@aux)-@cont))
	SET @cont = @cont + 1
	END

	IF(@res%11 < 0)
	BEGIN
		SET @res = 0
	END
	ELSE
	BEGIN
		SET @res = 11-(@res%11)
	END

	IF(SUBSTRING(@cpf, (9+@aux), 1) != @res)
	BEGIN
		SET @valido = 0
	END

	IF(@aux = 1)
	BEGIN
		SET @prime = @res
	END
	ELSE IF(@prime = @res)
	BEGIN
		SET @valido = 0
	END

	SET @aux = @aux + 1	
END


IF (@valido = 1)
BEGIN 
	PRINT 'CPF VALIDO'
END
ELSE
BEGIN
	PRINT 'CPF INVALIDO'
END