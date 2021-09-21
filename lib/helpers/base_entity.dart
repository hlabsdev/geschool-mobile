

abstract class BaseEntity {

  BaseEntity();

  Map<String, dynamic> toDatabase() ;

  fromDatabase( Map<String, dynamic> json ) ;


}