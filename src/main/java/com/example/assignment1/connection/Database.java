package com.example.assignment1.connection;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;

public interface Database {
    default Connection establishConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/mobileDatabase";
        return DriverManager.getConnection(url,"root","root");
    }
    ResponseEntity<Map<String, String>> create(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> update(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> getUser(JSONObject credentials) throws SQLException, ClassNotFoundException, JSONException;
    ResponseEntity<Map<String, String>> isUserExist(JSONObject user) throws SQLException, ClassNotFoundException, JSONException;
}
