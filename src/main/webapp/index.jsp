<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DobreTech Java Dynamic App - DevOps</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        h1 {
            color: #333;
        }
        .message {
            padding: 10px;
            background-color: #e9f7ef;
            border-left: 5px solid #2ecc71;
            margin-bottom: 20px;
        }
        form {
            margin-top: 20px;
        }
        input[type="text"] {
            padding: 8px;
            width: 200px;
        }
        input[type="submit"] {
            padding: 8px 15px;
            background-color: #3498db;
            color: white;
            border: none;
            cursor: pointer;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #3498db;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Java Web Application - DevOps</h1>
        
        <div class="message">
            <c:if test="${not empty message}">
                <p>${message}</p>
            </c:if>
            <c:if test="${empty message}">
                <p>Welcome to DobreTech Java Dynamic DevOps Application!</p>
            </c:if>
        </div>
        
        <form action="hello" method="get">
            <label for="name">Enter your name:</label>
            <input type="text" id="name" name="name">
            <input type="submit" value="Submit">
        </form>
        
        <a href="users">View Users</a>
    </div>
</body>
</html>
