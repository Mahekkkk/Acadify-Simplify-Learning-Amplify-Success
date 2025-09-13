<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Acadify - Register</title>
<style>
:root {
	--primary: #2C3D73;
	--secondary: #7CAADC;
	--accent: #FFD372;
	--accent-hover: #F15B42;
	--background: #FDF6FA;
	--text-color: #2C3D73;
	--quote-pink: #F49CC4;
}

body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: var(--background);
	margin: 0;
	padding: 0;
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	color: var(--text-color);
}

.register-card {
	background: white;
	padding: 2.5rem;
	border-radius: 20px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	width: 100%;
	max-width: 420px;
	border-top: 10px solid var(--accent);
}

.register-card h1 {
	color: var(--primary);
	text-align: center;
	margin-bottom: 2rem;
}

.form-group {
	margin-bottom: 1.5rem;
}

label {
	display: block;
	margin-bottom: 0.5rem;
	font-weight: 600;
	color: var(--primary);
}

input[type="text"], input[type="email"], input[type="password"] {
	width: 100%;
	padding: 10px 12px;
	border: 2px solid var(--secondary);
	border-radius: 8px;
	font-size: 1rem;
	transition: border-color 0.3s;
}

input:focus {
	border-color: var(--accent);
	outline: none;
}

.error {
	color: red;
	font-size: 0.9rem;
	margin-bottom: 1rem;
}

button {
	width: 100%;
	padding: 12px;
	background: var(--primary);
	color: white;
	font-weight: bold;
	font-size: 1rem;
	border: none;
	border-radius: 30px;
	cursor: pointer;
	transition: background 0.3s ease, transform 0.2s ease;
	box-shadow: 0 8px 20px rgba(255, 211, 114, 0.4);
}

button:hover {
	background: var(--accent-hover);
	transform: scale(1.03);
}

.login-link {
	text-align: center;
	margin-top: 1.5rem;
	font-size: 0.95rem;
}

.login-link a {
	color: var(--secondary);
	font-weight: 600;
	text-decoration: none;
}

.login-link a:hover {
	text-decoration: underline;
	color: var(--accent-hover);
}

@media ( max-width : 500px) {
	.register-card {
		padding: 2rem;
		margin: 1rem;
	}
}
</style>
<script>
	function validateUsername() {
		const username = document.getElementById("username");
		const usernameError = document.getElementById("usernameError");
		const pattern = /^[A-Za-z]+$/;

		if (!pattern.test(username.value)) {
			usernameError.textContent = "Username must contain only alphabets (A-Z, a-z)";
			return false;
		} else {
			usernameError.textContent = "";
			return true;
		}
	}

	function validateEmail() {
		const email = document.getElementById("email");
		const emailError = document.getElementById("emailError");
		const pattern = /^[A-Za-z][A-Za-z0-9._%+-]*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

		if (!pattern.test(email.value)) {
			emailError.textContent = "Please enter a valid email starting with a letter.";
			return false;
		} else {
			emailError.textContent = "";
			return true;
		}
	}

	function validateForm() {
		const validUsername = validateUsername();
		const validEmail = validateEmail();
		return validUsername && validEmail;
	}
</script>

</head>
<body>
	<div class="register-card">
		<h1>Register for Acadify</h1>

		<%
		if (request.getAttribute("errorMessage") != null) {
		%>
		<p class="error"><%=request.getAttribute("errorMessage")%></p>
		<%
		}
		%>

		<form action="register" method="post" novalidate
			onsubmit="return validateForm();">
			<div class="form-group">
				<label for="username">Username:</label> <input type="text"
					id="username" name="username" required oninput="validateUsername()">
				<div class="error" id="usernameError"></div>
			</div>

			<div class="form-group">
				<label for="email">Email:</label> <input type="email" id="email"
					name="email" required oninput="validateEmail()">
				<div class="error" id="emailError"></div>
			</div>


			<div class="form-group">
				<label for="password">Password:</label> <input type="password"
					id="password" name="password" required>
			</div>

			<button type="submit">Register</button>
		</form>



		<div class="login-link">
			<p>
				Already have an account? <a href="login.jsp">Login here</a>
			</p>
		</div>
	</div>
</body>
</html>
