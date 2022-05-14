package com.example.assignment1.connection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;

public interface Database {
    default Connection establish_connection() throws SQLException, ClassNotFoundException {
        String url = "jdbc:mysql://localhost:3306/mobileDatabase";
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection(url,"root","root");
    }
    ResponseEntity<Map> create(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map> update(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map> getUser(JSONObject credentials) throws SQLException, ClassNotFoundException, JSONException;
    ResponseEntity<Map> isUserExist(JSONObject user) throws SQLException, ClassNotFoundException, JSONException;
}
