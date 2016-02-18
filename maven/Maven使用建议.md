*2016/01/30 星期六 10:04:26*

----------
这里就不讲安装Maven了，主要讲一些本人在使用过程中的一些经验和建议。
## 关于setings.xml配置
### 建议更改本地仓库
maven的本地仓库默认在`${user.home}/.m2/repository`，为了避免重装系统和其他因素导致本地仓库意外丢失，墙裂建议将本地仓库位置设置在你的工作目录下。例如：
```xml
<localRepository>
  E:\Workstation\JavaTool\maven\.m2\repository
</localRepository>
```
### 建议使用国内的镜像仓库(*```墙外的同学请忽略```*)###  
国内的情况大家都清楚，GitHub都经常挂，有时候maven在后台半天也更新不到。有条件的搭私服当然是最好，没条件的话有选个靠谱的国内镜像站。我用的是[http://maven.oschina.net/help.html](http://maven.oschina.net/help.html "maven.oschina.net")
```xml
<mirrors>
   <mirror>
		<id>nexus-osc</id>
		<mirrorOf>central</mirrorOf>
		<name>Nexus osc</name>
		<url>http://maven.oschina.net/content/groups/public/</url>
	</mirror>
	<mirror>
		<id>nexus-osc-thirdparty</id>
		<mirrorOf>thirdparty</mirrorOf>
		<name>Nexus osc thirdparty</name>
		<url>http://maven.oschina.net/content/repositories/thirdparty/</url>
	</mirror>
</mirrors>
```
### 在IDE里*`Update Project`* JDK版本更改问题 ###
如果没有在setting里配置jdk版本，或是在pom指定jdk配置，`Update Project`就会被maven强制更改。  
建议配置：  
```xml
<profile>
     <id>jdk-1.7</id>  
     <activation>  
          <activeByDefault>true</activeByDefault>  
          <jdk>1.7</jdk>  
      </activation>  
<properties>  
<maven.compiler.source>1.7</maven.compiler.source>  
<maven.compiler.target>1.7</maven.compiler.target>  
<maven.compiler.compilerVersion>1.7</maven.compiler.compilerVersion>  
</properties>
```
## 关于maven插件 ##
### `maven-assembly-plugin` ###
打包maven项目是通常需要把所有依赖打成一个大包。这时就需要在pom文件中添加assembly插件。  
```xml
<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-assembly-plugin</artifactId>
				<version>2.2.2</version>
				<configuration>
					<archive>
						<manifest>
							<mainClass>com.nl.event.topo.SdcCaptureAtomEventTopo</mainClass>
						</manifest>
					</archive>
					<descriptorRefs>
						<descriptorRef>jar-with-dependencies</descriptorRef>
					</descriptorRefs>
				</configuration>
			</plugin>
```

### `maven-source-plugin` ###
如果希望在构时，把source也加入本地库需添加source插件。
```xml
<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-source-plugin</artifactId>
				<version>2.1.2</version>
				<executions>
					<execution>
						<id>attach-sources</id>
						<phase>verify</phase>
						<goals>
							<goal>jar-no-fork</goal>
						</goals>
					</execution>
				</executions>
</plugin>
```  

## 关于maven 命令 ##
### `mvn install:install-file` ###
将已有的jar包加入本地库。

`mvn install:install-file -DgroupId=org.gongice.util -DartifactId=custom-logger -Dversion=0.0.1 -Dpackaging=jar -Dfile=E:\Eclipse\workspace\custom-logger\target\custom-logger-0.0.1-SNAPSHOT.jar`
### `mvn assembly:assembly` ###
打包工程中所有依赖。  
```shell
E:\Eclipse\workspace>cd custom-logger
E:\Eclipse\workspace\custom-logger>mvn assembly:assembly
```
### `mvn source:jar` ###
打包源文件。
```shell
E:\Eclipse\workspace>cd custom-logger
E:\Eclipse\workspace\custom-logger>mvn source:jar
```
## 关于pom.xml的一些配置##
[http://www.zuidaima.com/share/1781583829978112.htm](http://www.zuidaima.com/share/1781583829978112.htm "史上最全的maven pom.xml文件教程详解")  
## maven包查询 ##
[http://maven.oschina.net/](http://maven.oschina.net/ "maven.oschina.net")  
[http://mvnrepository.com/](http://mvnrepository.com/ "mvnrepository")
