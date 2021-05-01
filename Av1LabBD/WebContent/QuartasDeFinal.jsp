<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Quartas de Final</title>
</head>
<body>
	<div align="center">
		<form action="QuartasDeFinal" method="get">
		<h1>Quartas de Final</h1>
		<table border="1">
		<tr>
			<th>Mandante</th>
			<th>Vs</th>
			<th>Visitante</th>
		</tr>
		<c:if test="${jogos != null}">
				<c:forEach var="jogos" items="${jogos}">
					<tr>
						<td><c:out value="${jogos.getTimeA().getNomeTime()}" /></td>
						<td>x</td>
						<td><c:out value="${jogos.getTimeB().getNomeTime()}" /></td>
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