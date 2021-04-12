<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Gerar Jogos</title>
</head>
<body>
	<div align="center">
		<form action="GerarJogos" method="post">
		<table>
		<tr>
			<td><h1>Clique no botão para gerar os jogos!</h1></td>
		</tr>
		<tr>
			<td><input type="submit" name="gerar" id="gerar" 
						value="Gerar"></td>
		</tr>
		<c:if test="${not empty saida}">
					<tr><c:out value="${saida}"></c:out></tr>
				</c:if>
		</table>
		</form>
	</div>
</body>
</html>