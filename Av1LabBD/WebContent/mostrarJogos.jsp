<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Mostrar Jogos</title>
</head>
<body>
	<div align="center">
		<form action="MostrarJogos" method="post">
		<table>
		<tr>
			<td><h1>Informe a data do jogo</h1></td>
		</tr>
		<tr>
			<td><input type="date" name="dataJogo" id="dataJogo"
						placeholder="dataJogo"></td>
		</tr>
		<tr>
			<td><input type="submit" name="buscar" id="buscar" 
						value="Buscar"></td>
		</tr>
		<c:if test="${not empty dataJogo}">
			<tr><c:out value="${dataJogo}"></c:out></tr>
		</c:if>
		</table>		
		</form>
		<form action="MostrarJogos" method="get">
		<table border="1">
			<c:if test="${jogos != null}">
				<th>Mandante</th>
				<th>x</th>
				<th>Visitante</th>
				<c:forEach var="jogos" items="${jogos}">
					<tr>
						<th><c:out value="${jogos.getTimeA().getNomeTime()}" /></th>
						<th>x</th>
						<th><c:out value="${jogos.getTimeB().getNomeTime()}" /></th>
					</tr>
				</c:forEach>
			</c:if>
		</table>
		
		<c:if test="${not empty saida}">
					<tr><c:out value="${saida}"></c:out></tr>
				</c:if>
		</form>
		
	</div>
</body>
</html>