package com.example.assignment1.connection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.ResponseEntity;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface StoresDatabase {
    default Connection establishConnection() throws SQLException {
        String url = "jdbc:mysql://bdc51d26dcc0d2:c7c63d4f@us-cdbr-east-05.cleardb.net/heroku_9f02f37849b58f3?reconnect=true";
        Connection connection = DriverManager.getConnection(url, "bdc51d26dcc0d2", "c7c63d4f");
        return connection;
    }

    ResponseEntity<List<Map<String, String>>> read() throws SQLException;

    ResponseEntity<List<Map<String, String>>> listAllFavorites(JSONObject user) throws SQLException;

    ResponseEntity<Map<String, String>> addToFavorite(JSONObject user) throws SQLException;

    ResponseEntity<Map<String, String>> getStore(JSONObject store) throws SQLException;

    ResponseEntity<Map<String, String>> isFavoriteExist(JSONObject user) throws SQLException;
}
