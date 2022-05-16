package com.example.assignment1.security;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import com.example.assignment1.connection.Database;
import com.example.assignment1.connection.UserData;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SignatureException;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

public class JwtTokenUtil implements Serializable {

    private static final long serialVersionUID = -2550185165626007488L;
    public static final long JWT_TOKEN_VALIDITY = 5 * 60 * 60;
    Database database = new UserData();
    UserData userData = new UserData();
    private static final String SECRET = "MTIzNDU2Nzg=";
    private static final String MESSAGE = "message";
    private static final String ID = "id";
    private static final String TOKEN = "token";
    private static final String AUTHORIZED = "Authorized User";
    private static final String UNAUTHORIZED = "unauthorized User";

    //retrieve username from jwt token
    public String getUserFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);
    }

    //retrieve expiration date from jwt token
    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }
    //for retrieveing any information from token we will need the secret key
    public Claims getAllClaimsFromToken(String token) {
        return Jwts.parser().setSigningKey(SECRET).parseClaimsJws(token).getBody();
    }

    //check if the token has expired
    private Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }

    private String getUserData(JSONObject user){
        JSONObject result = new JSONObject();
        result.put(ID, user.getString(ID));
        user.remove(ID);
        return result.toString();
    }

    public JSONObject getIdFromToken(JSONObject tokenJson){
        String token = tokenJson.getString(TOKEN);
        String id = getUserFromToken(token);
        JSONObject idJson = new JSONObject(id);
        return idJson;
    }
    //generate token for user
    public String generateToken(Map<String, String> userDetails) {
        JSONObject user = new JSONObject(userDetails);
        Map<String, Object> claims = new HashMap<>();
        return doGenerateToken(claims, user);
    }
    //while creating the token -
    //1. Define  claims of the token, like Issuer, Expiration, Subject, and the ID
    //2. Sign the JWT using the HS512 algorithm and secret key.
    //3. According to JWS Compact Serialization(https://tools.ietf.org/html/draft-ietf-jose-json-web-signature-41#section-3.1)
    //   compaction of the JWT to a URL-safe string
    private String doGenerateToken( Map<String, Object> claims, JSONObject user) {
        return Jwts.builder().setClaims(claims).setSubject(getUserData(user)).setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + JWT_TOKEN_VALIDITY * 1000))
                .signWith(SignatureAlgorithm.HS512, SECRET).compact();
    }

    //validate token
   /* public ResponseEntity<Map<String, String>> validateToken(JSONObject user) {
        Map<String, String> message = new HashMap<>();
        try{
            String userFromToken = sortUserData(getUserFromToken(user.getString(TOKEN)));
            String passedUser = sortUserData(convertToMapFormat(user));
            if(userFromToken.equals(passedUser) && !isTokenExpired(user.getString(TOKEN))){
                message.put(MESSAGE, AUTHORIZED);
                return new ResponseEntity<>(message, HttpStatus.OK);
            }
            message.put(MESSAGE, UNAUTHORIZED);
            return new ResponseEntity<>(message, HttpStatus.UNAUTHORIZED);
        }
        catch (SignatureException e){
            message.put(MESSAGE, UNAUTHORIZED);
            return new ResponseEntity<>(message, HttpStatus.UNAUTHORIZED);
        }
        catch (JSONException e){
            message.put(MESSAGE, "Json keys are not correct");
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }*/
    public ResponseEntity<Map<String, String>> validateToken(JSONObject user) {
        Map<String, String> message = new HashMap<>();
        try{
            String token = user.getString(TOKEN);
            if(!isTokenExpired(token)){
                message.put(MESSAGE, AUTHORIZED);
                return new ResponseEntity<>(message, HttpStatus.OK);
            }
            message.put(MESSAGE, UNAUTHORIZED);
            return new ResponseEntity<>(message, HttpStatus.UNAUTHORIZED);
        }
        catch (SignatureException e){
            message.put(MESSAGE, UNAUTHORIZED);
            return new ResponseEntity<>(message, HttpStatus.UNAUTHORIZED);
        }
        catch (JSONException e){
            message.put(MESSAGE, "Json keys are not correct");
            return new ResponseEntity<>(message, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}