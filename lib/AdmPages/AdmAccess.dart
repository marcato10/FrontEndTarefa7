import 'dart:core';

import 'package:flutter/material.dart';
import 'package:login_page/AlunoPages/AlunoAccess.dart';
import 'Cursos.dart';
import 'Perguntas.dart';
import 'QuizPage.dart';
import 'Treinamentos.dart';
import 'Usuarios.dart';
import 'VagasEmpregoAdm.dart';

List<NavigationRailDestination> destinationsAdm = [
  const NavigationRailDestination(
    icon: Icon(Icons.class_outlined),
    selectedIcon: Icon(Icons.class_rounded),
    label: Text('Cursos'),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.fitness_center_outlined),
    label: Text('Treinamentos'),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.account_box_outlined),
    label: Text('Usuários'),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.business_center_outlined),
    label: Text('Vagas'),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.question_mark_outlined),
    label: Text('Perguntas'),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.quiz_outlined),
    label: Text('Quiz'),
  )
];

List<Widget>admWidgets =[
  CursosTelaADM(loggedUser: loggedUser),
  TreinamentosTelaADM(loggedUser: loggedUser),
  UsuariosTelaADM(loggedUser: loggedUser),
  VagasTelaADM(loggedUser: loggedUser),
  PerguntaScreenADM(loggedUser: loggedUser),
  QuizTelaADM(loggedUser: loggedUser)
];

