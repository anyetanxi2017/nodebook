Settings >> Editor >> File and Code Templates >> Class||Interface|| Enum
```
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME};#end
#parse("File Header.java")
/**
 * @author myrita
 * @date ${DATE} ${TIME}
 */
public class ${NAME} {
}

```
