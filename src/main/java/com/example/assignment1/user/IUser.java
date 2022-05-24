package com.example.assignment1.user;

import org.json.JSONException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IUser {
    ResponseEntity<Map<String, String>> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> updateProfile(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<Map<String, String>> getUser(@RequestBody String id) throws JSONException, SQLException, ClassNotFoundException;
    ResponseEntity<List<Map<String,String>>> getStores(@RequestBody String user) throws JSONException, SQLException;

    @RequestMapping("getStore")
    @PostMapping
    ResponseEntity<Map<String,String>> getStore(@RequestBody String user) throws JSONException, SQLException;

    public ResponseEntity<List<Map<String, String>>> listAllFavorites(@RequestBody String user) throws JSONException, SQLException;

    @RequestMapping("addToFavorite")
    @PostMapping
    ResponseEntity<Map<String, String>> addToFavorite(@RequestBody String user) throws JSONException, SQLException;

    @RequestMapping("isFavoriteExist")
    @PostMapping
    ResponseEntity<Map<String, String>> isFavoriteExist(@RequestBody String favorite) throws JSONException, SQLException;
}
