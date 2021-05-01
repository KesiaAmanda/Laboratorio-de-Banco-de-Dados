<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Classificacao Geral</title>
</head>
<body>
	<div align="center">
		<form action="Geral" method="get">
		<h1>Classificacao Geral</h1>
				<table border="1">
					<tr>
						<td>Nome</td>
						<td>Total Jogos Disputados</td>
						<td>Vitorias</td>
						<td>Empates</td>
						<td>Derrotas</td>
						<td>Gols Marcados</td>
						<td>Gols Sofridos</td>
						<td>Saldo de Gols</td>
						<td>Pontos</td>
					</tr>
					<c:if test="${listaTimes != null}">
						<c:forEach var="times" items="${listaTimes}">
							<tr>
								<td><c:out value="${times.getNomeTime()}"/></td>
								<td><c:out value="${times.getClassificacao().getNum_jogos_disputados()}"/></td>
								<td><c:out value="${times.getClassificacao().getVitorias()}"/></td>
								<td><c:out value="${times.getClassificacao().getEmpates()}"/></td>
								<td><c:out value="${times.getClassificacao().getDerrotas()}"/></td>
								<td><c:out value="${times.getClassificacao().getGols_marcado()}"/></td>
								<td><c:out value="${times.getClassificacao().getGols_sofridos()}"/></td>
								<td><c:out value="${times.getClassificacao().getSaldo_gols()}"/></td>
								<td><c:out value="${times.getClassificacao().getPontos()}"/></td>
								<c:if test="${fn:contains(rebaixados, times.getNomeTime())}">
									<td><c:out value="Zona de rebaixamento"/></td>
								</c:if>
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