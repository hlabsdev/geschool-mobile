import 'package:flutter/material.dart';

import 'package:geschool/core/utils/colors.dart';

// ignore: must_be_immutable
class CustomScrollViewScaffold extends StatelessWidget {
  FloatingActionButton floatingActionButton;
  Widget body;
  CustomAppBar appBar;
  bool shrinkWrap;
  ScrollPhysics physics;
  ScrollController controller;
  bool primary;
  bool scrollable = true;

  CustomScrollViewScaffold({
    Key key,
    this.floatingActionButton,
    this.body,
    this.appBar,
    this.shrinkWrap,
    this.physics,
    this.controller,
    this.primary,
    this.scrollable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        primary: primary != null ? primary : false,
        controller: controller,
        physics: scrollable ? physics : NeverScrollableScrollPhysics(),
        shrinkWrap: shrinkWrap != null ? shrinkWrap : false,
        slivers: [
          appBar,
          SliverFillRemaining(
            child: body,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  bool pinned;
  List<Color> colors;
  List<Widget> actions;
  AlignmentGeometry begin;
  AlignmentGeometry end;
  Widget title;
  Widget customTitle;
  PreferredSizeWidget bottom;
  double elevation;
  bool floating;
  double expandedHeight;
  // final ;

  CustomAppBar({
    Key key,
    this.colors,
    this.actions,
    this.pinned,
    this.begin,
    this.end,
    this.title,
    this.customTitle,
    this.bottom,
    this.elevation,
    this.floating,
    this.expandedHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: true,
      pinned: pinned != null ? pinned : true,
      flexibleSpace: Container(
        padding: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin != null ? begin : Alignment.topCenter,
            end: end != null ? end : Alignment.bottomCenter,
            colors: colors != null ? colors : [GreenLight, PafpeGreen],
          ),
        ),
        child: customTitle,
      ),
      title: title,
      expandedHeight: expandedHeight,
      actions: actions,
      bottom: bottom != null ? bottom : bottom,
      elevation: elevation,
      floating: floating != null ? floating : false,
    );
  }
}

/* 
Interface mobile geschool:
  - mes absences (80%)
  - mes missions (80%)
  - mes affectations (80%)

  *Taches (Ici ce sont les details par lesquels il faut passer pour les taches affichés dans le planning)*
  - liste des taches (80%)
  - ajouter une tache (80%)
  - modifier une tache(Definir ou modifier le rappel) (80%)
  - ajouter un rapport sur une tache (80%)
  - modifier le rapport d'une tache (80%)
  
  *Refactoring du code (A pris un peu de temps et continuera tout au long du developpement)*
    - Regroupage des interfaces qui se repetent ou se ressemblent en widget reutilisables (70%)
    - Amelioration de certaines interfaces quand necessaires

  *Notes (Ici ce sont les details par lesquels il faut passer pour les taches affichés dans le planning)*
  - lister les apprenants par classe (40%)
  - afficher les notes d'un apprenant (0% a faire)
  - enregistrer les notes d'un apprenant (0% a faire)
  - modifier les notes d'un apprenant (0% a faire)
  - consulter mes notes (pqr l'apprenant) (0% a faire)
*/
