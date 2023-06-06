import 'package:flutter/material.dart';
import '../apptheme.dart';

class DocumentType {
  const DocumentType(this.label, this.icon, this.typeID);

  final String label;
  final Widget icon;
  final int typeID;

}


List<DocumentType> listTypes = <DocumentType>[
  DocumentType('grave',Image.asset('assets/images/cross_icon.png', height: 25, width: 25,),0),
  DocumentType('chapel',Icon(Icons.church_outlined,color: AppTheme.typeIconColor),1),
  DocumentType('chapel2',Icon(Icons.church_outlined,color: AppTheme.typeIconColor),2),
  DocumentType('chapel3',Image.asset('assets/images/cross_icon.png', height: 25, width: 25,),3),
  DocumentType('chapel4',Icon(Icons.church_outlined,color: AppTheme.typeIconColor),4),
  DocumentType('cemetery_cholera',Image.asset('assets/images/cross_icon.png', height: 25, width: 25,),5),
  DocumentType('other',Icon(Icons.question_mark_outlined,color: AppTheme.typeIconColor),6),

];
