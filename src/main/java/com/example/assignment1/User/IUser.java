package com.example.assignment1.User;

import org.json.JSONException;
import org.json.simple.parser.ParseException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;

import java.sql.SQLException;
import java.util.Map;

public interface IUser {
    ResponseEntity<Map> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException, ParseException;
    ResponseEntity<Map> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map> updateProfile(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
}
