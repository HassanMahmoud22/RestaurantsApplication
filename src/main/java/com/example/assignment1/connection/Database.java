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
        String url = "jdbc:mysql://bdc51d26dcc0d2:c7c63d4f@us-cdbr-east-05.cleardb.net/heroku_9f02f37849b58f3?reconnect=true";
        Connection connection= DriverManager.getConnection(url,"bdc51d26dcc0d2","c7c63d4f");
        return connection;
    }
    ResponseEntity<Map<String, String>> create(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> update(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> read(JSONObject jsonObject) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> getIdByCredentials(JSONObject credentials) throws SQLException, ClassNotFoundException, JSONException;
    ResponseEntity<Map<String, String>> isUserExist(JSONObject user) throws SQLException, ClassNotFoundException, JSONException;
}
