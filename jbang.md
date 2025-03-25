# Example using jbang to have a script like Java program

## install jbang
on linux use your package manager or [sdkman](https://sdkman.io), on mac ``` brew install jbang ```

## testing with this script
- save as 'hello'
- make executeable ``` chmod +x hello ```
- run ``` ./hello ```
 
```java
#!/usr/bin/env jbang

//DEPS com.google.code.gson:gson:2.10.1
//DEPS org.apache.commons:commons-lang3:3.12.0

import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;

class Hello {
    public static void main(String[] args) {
        Gson gson = new Gson();
        String messageText = "hallo JAVA";

        // Use StringUtils.capitalize()
        String capitalized = StringUtils.capitalize(messageText.toUpperCase());

        String json = gson.toJson(new Message(capitalized));
        System.out.println(json);
    }
}

class Message {
    String text;
    Message(String text) {
        this.text = text;
    }
}
```
