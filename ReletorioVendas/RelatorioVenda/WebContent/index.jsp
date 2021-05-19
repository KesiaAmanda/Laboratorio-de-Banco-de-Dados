<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Relatorio Venda</title>
</head>
<body>
	<div align="center">
		<form action="Venda" method="post" target="_blank">
		<table>
		<tr>
			<td>
				<h1>Gerador nota compra</h1>
			</td>
			<td>
			 	<img src="Files/logo.png">
			 </td>
		</tr>
		<tr>
			<td><p>Documento do cliente:</p></td>
			<td><input type="text" name="cpfCliente" id="cpfCliente"
						placeholder=""></td>
		</tr>
		<tr>
			<td><p>Data da compra:</p></td>
			<td><input type="date" name="dataCompra" id="dataCompra"
						></td>
		</tr>
		<tr>
			<td><input type="submit" name="gerar" id="gerar" 
						value="Enviar">
			</td>
		</tr>
		<c:if test="${not empty saida}">
					<tr><c:out value="${saida}"></c:out></tr>
				</c:if>
		</table>
		</form>
		</div>
</body>
</html>