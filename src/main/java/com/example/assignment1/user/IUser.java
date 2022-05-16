package com.example.assignment1.user;

import org.json.JSONException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;

import java.sql.SQLException;
import java.util.Map;

public interface IUser {
    ResponseEntity<Map<String, String>> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> updateProfile(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> getUser(@RequestBody String id) throws JSONException, SQLException, ClassNotFoundException;
}
