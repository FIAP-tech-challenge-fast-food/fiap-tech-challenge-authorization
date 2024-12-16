package com.fiap.techchallenge.fastfood.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class LambdaHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    private static final String DB_URL = "jdbc:mysql://techchallenge.c6rsbj8ojum0.us-east-1.rds.amazonaws.com:3306/techchallenge";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root_password";
    private static final String SECRET_KEY = "cd16710b3548f4afedccffc13cdc1cfa48c96dcd90fc37b2ae518d7f969f11e4";

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context context) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> user = null;
    
        try {
            String cpf = (String) event.get("cpf");
            
            if (cpf != null && !cpf.isEmpty()) {
                user = getUserByCpf(cpf);
            }
    
            String token;
            
            if (user != null) {
                token = generateJwtToken(user);
            } else {
                Map<String, Object> genericUser = new HashMap<>();
                genericUser.put("cpf", "Anonymous");
                genericUser.put("name", "Anonymous User");
                token = generateJwtToken(genericUser);
            }
    
            response.put("statusCode", 200);
            response.put("body", String.format("{\"token\": \"%s\"}", token));
        } catch (Exception e) {
            context.getLogger().log("Error: " + e.getMessage());
            response.put("statusCode", 500);
            response.put("body", "{\"error\": \"Internal Server Error\"}");
        }
    
        return response;
    }    

    private Map<String, Object> getUserByCpf(String cpf) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT cpf, name FROM users WHERE cpf = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, cpf);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("cpf", rs.getString("cpf"));
                    user.put("name", rs.getString("name"));
                    return user;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to fetch user from MySQL", e);
        }
        
        return null;
    }

    private String generateJwtToken(Map<String, Object> user) {
        return Jwts.builder()
                .setSubject((String) user.get("cpf"))
                .claim("name", user.getOrDefault("name", "User"))
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY.getBytes())
                .compact();
    }
}