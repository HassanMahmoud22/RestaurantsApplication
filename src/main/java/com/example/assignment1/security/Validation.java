package com.example.assignment1.security;

import com.example.assignment1.constants.Keys;
import com.example.assignment1.constants.Messages;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Validation {

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
            if(!isValidName(user.getString(Keys.NAME))){
                message.put(Keys.MESSAGE, Messages.NAMENOTVALID);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            if(!isValidEmail(user.getString(Keys.EMAIL))){
                message.put(Keys.MESSAGE, Messages.EMAILNOTVALID);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            if((user.getString(Keys.LEVEL).length() > 0) && (user.getInt(Keys.LEVEL) < 1 || user.getInt(Keys.LEVEL) > 4)){
                message.put(Keys.MESSAGE, Messages.LEVELNOTVALID);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            if(user.getString(Keys.PASSWORD).length() < 8) {
                message.put(Keys.MESSAGE, Messages.PASSWORDNOTVALID);
                return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
            }
            message.put(Keys.MESSAGE, Messages.VALIDUSER);
            return new ResponseEntity<>(message, HttpStatus.OK);
        }catch (JSONException e){
            message.put(Keys.MESSAGE, Messages.JSONKEYSNOTVALID);
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
