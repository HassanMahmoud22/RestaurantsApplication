package com.example.assignment1.user;

import com.example.assignment1.connection.*;
import com.example.assignment1.constants.Keys;
import com.example.assignment1.constants.Messages;
import com.example.assignment1.security.JwtTokenUtil;
import com.example.assignment1.security.Validation;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@CrossOrigin
@RequestMapping("/api/user")
@RestController
public class UserController implements IUser {
    Database database = new UserData();
    Validation validation = new Validation();
    JwtTokenUtil jwtTokenUtil = new JwtTokenUtil();
    @RequestMapping("register")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> register(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException{
        JSONObject userJson = new JSONObject(user);
        ResponseEntity<Map<String, String>> UserValidationResponse = validation.isValidUser(userJson);
        if(UserValidationResponse.getStatusCode() == HttpStatus.OK){
            ResponseEntity<Map<String, String>> signupResponse = database.create(userJson);
            if(signupResponse.getStatusCode() == HttpStatus.OK)
                signupResponse.getBody().put(Keys.TOKEN, jwtTokenUtil.generateToken(database.getIdByCredentials(userJson).getBody()));
            return signupResponse;
        }
       else
           return UserValidationResponse;
    }

    @RequestMapping("login")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> login(@RequestBody String credentials) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject credentialsJson = new JSONObject(credentials);
        ResponseEntity<Map<String, String>> loginResponse = database.isUserExist(credentialsJson);
        if(loginResponse.getStatusCode() == HttpStatus.OK){
            loginResponse.getBody().put(Keys.MESSAGE, Messages.LOGINSUCCESS);
            loginResponse.getBody().put(Keys.TOKEN, jwtTokenUtil.generateToken(database.getIdByCredentials(credentialsJson).getBody()));
            return loginResponse;
        }
        loginResponse.getBody().put(Keys.MESSAGE, Messages.LOGINFAILED);
        return loginResponse;
    }

    @RequestMapping("updateProfile")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> updateProfile(@RequestBody String user) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject userJson = new JSONObject(user);
        if(validation.isValidUser(userJson).getStatusCode() == HttpStatus.OK){
            if(jwtTokenUtil.validateToken(userJson).getStatusCode() == HttpStatus.OK){
                    userJson.put(Keys.ID, jwtTokenUtil.getIdFromToken(userJson).getString(Keys.ID));
                    return database.update(userJson);
            }
            return jwtTokenUtil.validateToken(userJson);
        }
        return validation.isValidUser(userJson);
    }

    @RequestMapping("getUser")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> getUser(@RequestBody String token) throws JSONException, SQLException, ClassNotFoundException {
        JSONObject tokenJson = new JSONObject(token);
        ResponseEntity<Map<String, String>> validationResponse = jwtTokenUtil.validateToken(tokenJson);
        if (validationResponse.getStatusCode() == HttpStatus.OK) {
            JSONObject id = jwtTokenUtil.getIdFromToken(tokenJson);
            return database.read(id);
        }
        return validationResponse;
    }

    @RequestMapping("getStores")
    @PostMapping
    @Override
    public ResponseEntity<List<Map<String,String>>> getStores(@RequestBody String user) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        List<Map<String, String>> dummy = new ArrayList<>();
        JSONObject userJson = new JSONObject(user);
        if(jwtTokenUtil.validateToken(userJson).getStatusCode() == HttpStatus.OK){
            return storesDatabase.read();
        }
        return new ResponseEntity<>(dummy, jwtTokenUtil.validateToken(userJson).getStatusCode());
    }

    @RequestMapping("getStore")
    @PostMapping
    @Override
    public ResponseEntity<Map<String,String>> getStore(@RequestBody String request) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        JSONObject requestJson = new JSONObject(request);
        ResponseEntity<Map<String, String>> validationResponse = jwtTokenUtil.validateToken(requestJson);
        if(validationResponse.getStatusCode() == HttpStatus.OK){
            return storesDatabase.getStore(requestJson);
        }
        return validationResponse;
    }

    @RequestMapping("listAllFavorites")
    @PostMapping
    @Override
    public ResponseEntity<List<Map<String, String>>> listAllFavorites(@RequestBody String user) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        JSONObject userJson = new JSONObject(user);
        List<Map<String, String>> dummy = new ArrayList<>();
        if(jwtTokenUtil.validateToken(userJson).getStatusCode() == HttpStatus.OK){
            userJson.put(Keys.ID, jwtTokenUtil.getIdFromToken(userJson).getString(Keys.ID));
            return storesDatabase.listAllFavorites(userJson);
        }
        return new ResponseEntity<>(dummy, jwtTokenUtil.validateToken(userJson).getStatusCode());
    }

    @RequestMapping("addToFavorite")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> addToFavorite(@RequestBody String user) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        JSONObject userJson = new JSONObject(user);
        ResponseEntity<Map<String, String>> validationResponse = jwtTokenUtil.validateToken(userJson);
        if(validationResponse.getStatusCode() == HttpStatus.OK){
            userJson.put(Keys.USERID, jwtTokenUtil.getIdFromToken(userJson).getString(Keys.ID));
            return storesDatabase.addToFavorite(userJson);
        }
        return validationResponse;
    }

    @RequestMapping("isFavoriteExist")
    @PostMapping
    @Override
    public ResponseEntity<Map<String, String>> isFavoriteExist(@RequestBody String favorite) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        JSONObject favoriteJson = new JSONObject(favorite);
        ResponseEntity<Map<String, String>> validationResponse = jwtTokenUtil.validateToken(favoriteJson);
        if(validationResponse.getStatusCode() == HttpStatus.OK){
            favoriteJson.put(Keys.USERID, jwtTokenUtil.getIdFromToken(favoriteJson).getString(Keys.ID));
            return storesDatabase.isFavoriteExist(favoriteJson);
        }
        return validationResponse;
    }

    @RequestMapping("getProducts")
    @PostMapping
    @Override
    public ResponseEntity<List<Map<String,String>>> getProducts(@RequestBody String store) throws JSONException, SQLException {
        ProductsDatabase productsDatabase = new ProductsData();
        List<Map<String, String>> dummy = new ArrayList<>();
        JSONObject productsJson = new JSONObject(store);
        if(jwtTokenUtil.validateToken(productsJson).getStatusCode() == HttpStatus.OK){
            return productsDatabase.getProducts(productsJson);
        }
        return new ResponseEntity<>(dummy, jwtTokenUtil.validateToken(productsJson).getStatusCode());
    }

    @RequestMapping("getAllProducts")
    @PostMapping
    @Override
    public ResponseEntity<List<Map<String,String>>> getAllProducts(@RequestBody String token) throws JSONException, SQLException {
        ProductsDatabase productsDatabase = new ProductsData();
        List<Map<String, String>> dummy = new ArrayList<>();
        JSONObject tokensJson = new JSONObject(token);
        if(jwtTokenUtil.validateToken(tokensJson).getStatusCode() == HttpStatus.OK){
            return productsDatabase.getAllProducts();
        }
        return new ResponseEntity<>(dummy, jwtTokenUtil.validateToken(tokensJson).getStatusCode());
    }

    @RequestMapping("getSearchedStores")
    @PostMapping
    @Override
    public ResponseEntity<List<Map<String,String>>> getSearchedStores(@RequestBody String productId) throws JSONException, SQLException {
        StoresDatabase storesDatabase = new StoresData();
        List<Map<String, String>> dummy = new ArrayList<>();
        JSONObject productIdJson = new JSONObject(productId);
        if(jwtTokenUtil.validateToken(productIdJson).getStatusCode() == HttpStatus.OK){
            return storesDatabase.getSearchedStores(productIdJson);
        }
        return new ResponseEntity<>(dummy, jwtTokenUtil.validateToken(productIdJson).getStatusCode());
    }
}
