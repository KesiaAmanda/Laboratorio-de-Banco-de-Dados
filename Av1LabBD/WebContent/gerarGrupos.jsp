<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Gerar Grupos</title>
</head>
<body>
	<div align="center">
		<form action="GerarGrupos" method="post">
		<table>
		<tr>
			<td><input type="submit" name="gerar" id="gerar" 
						value="Gerar"></td>
		</tr>
		</table>
		</form>
		<form action="GerarGrupos" method="get">
			<c:if test="${grupos != null}">
				<c:forEach var="grupos" items="${grupos}">
				<table border="1">
					<tr>
						<th class="display-4"><c:out value="${grupos.getGrupo()}" /></th>
					</tr>
						<c:forEach var="times" items="${grupos.getTimes()}">
							<tr>
								<c:if test="${times.getNomeTime() == 'Corinthians' 
										|| times.getNomeTime() == 'Santos' 
										|| times.getNomeTime() == 'São Paulo' 
										|| times.getNomeTime() == 'Palmeiras'}">
									<td scope="row"><b><c:out value="${times.getNomeTime()}"/></b></td>
								</c:if>
								<c:if test="${times.getNomeTime() != 'Corinthians' 
										&& times.getNomeTime() != 'Santos' 
										&& times.getNomeTime() != 'São Paulo' 
										&& times.getNomeTime() != 'Palmeiras'}">
									<td scope="row"><c:out value="${times.getNomeTime()}"/></td>
								</c:if>
							</tr>
						</c:forEach>
				</table>
				</c:forEach>
			</c:if>
			<c:if test="${not empty saida}">
				<tr><c:out value="${saida}"></c:out></tr>
			</c:if>
		</form>
	</div>
</body>
</html>