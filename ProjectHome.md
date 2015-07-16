## **about** ##

the samplemath application framework (SMAF) is a RIA development framework for Flash and related technologies. it provides you with the foundation of a skeleton application that implements most common application responsibilities using best practices. not having to reinvent the wheel SMAF allows you to focus on the business logic aspects of your application.




## **advantages** ##

main advantages of architecting on this framework:

  * lightweight compile size, optimal runtime performance
  * agility in development by building around an existing core infrastructure
  * less prone to errors and bugs following best practices
  * endless freedom through a flexible composition model
  * promotes collaboration of development and creative by successfully separating implementation from layout




## **ambition** ##

the primary ambition of this framework is to streamline RIA development.

a secondary ambition is to ultimately create a framework that works well both in Flash and HTML 5. making application development and content publishing effortlessly [platform independent](http://samplemath.com/smaf/doc/wikka.php?wakka=Ambitions).




## **aesthetics** ##

SMAF is designed to be low level therefore highly flexible. the idea is to favor minimum viable implementations that remain lightweight compiled and in performance and can be conveniently and optimally extended for custom development purposes. instead of offering a robust framework of over-engineered components with templated look, feel and behavior, SMAF gives you a few low level building blocks that can be combined to achieve the most complex UI requirements.




## **technologies** ##

SMAF is currently geared around Flash application development, there is no HTML implementation yet. some `JavaScript` is being used on the front end along with minimum HTML and CSS to support flash and its communication with its host. (typically web browser but may be PC or mobile application wrapper)

the framework also includes a server-side deployable implementation including a database schema using MYSQL and web services supporting most common web application requirements implemented in PHP5.

one key concept based around rapid UI composition is the markup used by SMAF called SMXML, which is very similar to MXML for FLEX. it is capable of describing layout, style and event handling of complex UI compositions. this markup is essentially XML.




## **documentation** ##

read <a href='http://samplemath.com/smaf/doc'>Programming SMAF</a> and view the <a href='http://samplemath.com/smaf/ref/'>SMAF reference</a> for details.

test your SMXML composition using the [SMXML renderer](http://samplemath.com/smxml/)

for more info on planned releases please view the [release map](http://samplemath.com/smaf/ref/release_map.html)




## **source** ##

source versioned: 2.0.16

PLEASE BE ADVISED! while the sources of the project are already available in the repository it is not intended for public reuse before the 2.1 release. version 2.1 and higher should be stable public releases of SMAF.




## **contribution** ##

the SMAF team always welcomes developers to contribute to [various aspects](http://samplemath.com/smaf/doc/wikka.php?wakka=ContributionWelcome) of this project.


---


there are some third party AS3 classes included with smaf. a couple of them the framework depends on, and some other ones that are simply suggested to use as a best practice. the smaf crew is yet to contact all authors of these classes for approval before the first public release. you may see [the list of third party classes here](http://samplemath.com/smaf/ref/third_party_as3.html).