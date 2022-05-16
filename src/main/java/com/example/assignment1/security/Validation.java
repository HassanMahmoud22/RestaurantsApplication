package com.example.assignment1.security;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Validation {
    private static final String NAME = "name";
    private static final String GENDER = "gender";
    private static final String EMAIL = "email";
    private static final String LEVEL = "level";
    private static final String PASSWORD = "password";
    private static final String MESSAGE = "message";
    private static final String TOKEN = "token";

    private boolean isValidEmail(String email){
        if(email.length() == 0)
            return false;
        String regex = "^(.+)@(.+)$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }

    private boolean isValidName(String name) {
        if (name.length() == 0)
            return false;
        char[] characters = name.toCharArray();
        for (char c : characters) {
            if(Character.isDigit(c))
                return false;
        }
        return true;
    }

    public ResponseEntity<Map<String, String>> isValidUser(JSONObject user) {
        Map<String, String> message = new HashMap<>();
        try{
            if(!isValidName(user.getString(NAME))){
                message.put(MESSAGE, "The name isn't valid");
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            if(!isValidEmail(user.getString(EMAIL))){
                message.put(MESSAGE, "The email isn't valid");
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            if(user.getString(LEVEL).length() > 0){
                if(user.getInt(LEVEL) < 1 || user.getInt(LEVEL) > 4){
                    message.put(MESSAGE, "The Level isn't valid");
                    return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
                }
            }
            if(user.getString(PASSWORD).length() < 8) {
                message.put(MESSAGE, "The Password isn't valid");
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            message.put(MESSAGE, "valid user");
            return new ResponseEntity<>(message, HttpStatus.OK);
        }catch (JSONException e){
            message.put(MESSAGE, "Json keys are not correct");
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}