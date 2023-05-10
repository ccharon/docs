# **Migration Springboot3**
Hier wird nur die Umstellung von Springboot2 auf Springboot3 beschrieben. Die Umstellung auf Java 17 ist ein eigenes Thema, sollte aber gleichzeitig erfolgen. In der Regel sollte es bei unseren Projekten reichen die Version in der pom.xml von 11 auf 17 zu ändern.

Tekton sollte das können und es sollte mittlerweile auch java 17 tomcat images geben.


## **1 Quellen**
https://thorben-janssen.com/migrating-to-hibernate-6/
https://www.baeldung.com/spring-boot-3-migration
https://www.baeldung.com/spring-boot-3-spring-6-new

## **2 Umstellung**

### **2.1 Properties**

Änderungen an Properties
- spring.redis -> spring.data.redis
- spring.data.cassandra -> spring.cassandra
- spring.jpa.hibernate.use-new-id-generator entfernt
- server.max.http.header.size -> server.max-http-request-header-size
- spring.security.saml2.relyingparty.registration.{id}.identity-provider entfernt

Um veraltete Properties zu identifizieren kann man während man von 2 nach 3 migriert diese Abhängigkeit ins pom.xml einfügen,
wenn die Migration abeschlossen ist, bitte wieder entfernen!
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-properties-migrator</artifactId>
    <scope>runtime</scope>
</dependency>
```

Diese Dependency erstellt einen Bericht der beim Anwendungsstart ausgegeben wird. Weiterhin werden die die veralteten Properties zur Laufzeit migriert

### **2.2 Jakarta EE 10**

Die javax.persistence api ist umgezogen... falls man die explizit im pom.xml hat und nicht rausnehmen will (wäre im springboot bom mit drin) muss man die neue Version nutzen

```xml
<dependency>
    <groupId>jakarta.persistence</groupId>
    <artifactId>jakarta.persistence-api</artifactId>
    <version>3.1.0</version>
</dependency>
```

Gleiches gilt für die Servlet API, das ist jetzt auch im jakarte Package. Falls man weiterhin die Servlet API explizit im pom haben will dann die hier:

```xml
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.0.0</version>
</dependency>
```

### 2.3 Hibernate
Detailierte Informationen (falls man fiese Probleme bekommt) gibt es hier: https://thorben-janssen.com/migrating-to-hibernate-6/#Update_to_JPA_3

Falls man Hibernate explizit im pom.xml hat, rauswerfen. eine passende Hibernate Version ist im springboot bom enthalten. Sollte es trotzdem nötig sein Hibernate explizit einzubinden, dann so:

```xml
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.1.4.Final</version>
</dependency>
```
Wenn man das gemacht hat geht nichts mehr also weiter.

#### **2.3.1 Update auf JPA 3**
Hibernate 6 nutzt standardmäßig JPA3 ... wenn man explizit eine ätere Version im pom.xml hat, dann löschen.

Der Packagename aller enthaltenen Klassen/Annotationen hat sich geändert. 

``` javax.persistence.* -> jakarta.persistence.* ```

Am besten man macht einfach komplett suchen und ersetzen dann sollte es wieder gehn.

#### **2.3.2 Die Hibernate Criteria API ist tot**
alle Hibernate Criteria API Aufrufe müssen ersetzt werden.
Es gibt jetzt die JPA Criteria API. 

### **2.4 Webanwendungen**

#### **2.4.1 Trailing Slash Matching Configuration**

In Springboot 3 ist ```/api/blubb``` nicht mehr gleich ```/api/blubb/``` wenn man hinten ein ```/``` angfügt dann gibts ein 404.

Um das alte Verhalten, falls gewünscht wieder herzusellen brauchen wir eine Configklasse die WebMvcConfigurer oder WebFluxConfigurer (falls es ein reactive Service ist) implementiert

```java
public class WebConfiguration implements WebMvcConfigurer {

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.setUseTrailingSlashMatch(true);
    }

}
```

#### **2.4.2 Response Header Size**

Das Property ```server.max.http.header.size``` heisst jetzt: ```server.max-http-request-header-size```

und bezieht sich nurnoch auf den request Header. Will man den Response Header auch limitieren muss man das selbst machen. (Ich glaub das brauchen wir nicht)

```java
@Configuration
public class ServerConfiguration implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        factory.addConnectorCustomizers(new TomcatConnectorCustomizer() {
            @Override
            public void customize(Connector connector) {
                connector.setProperty("maxHttpResponseHeaderSize", "100000");
            }
        });
    }
}
```

#### **2.4.3 httpClient**
es wird jetzt der Apache HttpClient 5 genutzt falls der 4er explizit im pom.xml ist dann raus.


### **2.5 Spring Security**
gute Nachrichten. wenn es mit Springboot 2.7 und Spring Security 5.8 ging, dann sollte es auch mit Springboot und Spring Security 6 laufen.

### **2.6 Actuator Endpoints Sanitization**

In previous versions, Spring Framework automatically masks the values for sensitive keys on the endpoints /env and /configprops, which display sensitive information such as configuration properties and environment variables.
In this release, Spring changes the approach to be more secure by default.

Instead of only masking certain keys, it now masks the values for all keys by default. We can change this configuration by setting the properties management.endpoint.env.show-values (for the /env endpoint) or management.endpoint.configprops.show-values (for the /configprops endpoint) with one of these values:

    NEVER: no values shown
    ALWAYS: all the values shown
    WHEN_AUTHORIZED: all the values are shown if the user is authorized. For JMX, all the users are authorized. For HTTP, only a specific role can access the data.

