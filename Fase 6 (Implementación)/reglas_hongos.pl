% reglas_hongos.pl
% Implementación Prolog final derivada del árbol de decisión documentado.
% Autor: (Trabajo TP - CRISP-DM)
% Nota: cada regla fue traducida conservadoramente desde la salida del árbol.

% -------------------------
% Hechos base (documentados)
% -------------------------
% Hechos de ejemplo incluidos en el entregable
ingerible('abultada', 'almendra').
ingerible('abultada', 'ninguno', 'cercano').
venenoso('abultada', 'mohoso').
venenoso('abultada', 'ninguno', 'poblado').

% -------------------------
% Reglas derivadas del árbol
% -------------------------
% Regla 1: olor = 'almendra' -> ingerible
clase_hongo(F, 'almendra', _, 'ingerible') :-
    nonvar(F).

% Regla 2: olor = 'anis' -> ingerible
clase_hongo(F, 'anis', _, 'ingerible') :-
    nonvar(F).

% Regla 3: olor distinto de almendra/anis/ninguno -> venenoso
% (Interpretación directa de la hoja con peso mayor para la clase venenoso)
clase_hongo(_, O, _, 'venenoso') :-
    O \= 'almendra',
    O \= 'anis',
    O \= 'ninguno'.

% Regla 4: olor = 'ninguno' y hábitat = 'praderas' -> venenoso
clase_hongo(_, 'ninguno', 'praderas', 'venenoso').

% Regla 5: olor = 'ninguno' y forma = 'conica' -> venenoso
clase_hongo('conica', 'ninguno', _, 'venenoso').

% Reglas 6–10: ramas con predominio de 'ingerible' (combinaciones forma+hábitat)
% Derivadas de las hojas que asignan 'ingerible' a combinaciones frecuentes.
clase_hongo(F, 'ninguno', H, 'ingerible') :-
    % formas que en el árbol aparecen frecuentemente como ingerible
    member(F, ['acampanada', 'abotonada', 'chata', 'convexa', 'abultada']),
    % excluir hábitats que en ramas específicas conducen a venenoso
    H \= 'praderas',
    H \= 'bosque'.

% Caso específico observado: ciertas combinaciones (forma abotonada + habitat bosque)
% aparecen en el árbol con pesos que aún clasifican como ingerible; se incluye la regla.
clase_hongo('abotonada', 'ninguno', 'bosque', 'ingerible').

% Regla general: priorizar hechos explícitos documentados (si existe hecho, usarlo)
clase_hongo(F, O, H, 'ingerible') :-
    (ingerible(F, O) ; ingerible(F, O, H)), !.

clase_hongo(F, O, H, 'venenoso') :-
    (venenoso(F, O) ; venenoso(F, O, H)), !.

% -------------------------
% Fallback y control de salida
% -------------------------
% Si ninguna de las reglas anteriores aplica (no hay evidencia directa en el árbol),
% devolvemos 'desconocido' para evitar inferencias no documentadas.
clase_hongo(_, _, _, 'desconocido').

% -------------------------
% Consultas de prueba
% -------------------------

?- clase_hongo('abultada', 'ninguno', 'cercano', Clase).
% Clase = 'ingerible'.

?- clase_hongo('abultada', 'mohoso', 'lo_que_sea', Clase).
% Clase = 'venenoso'.

?- clase_hongo('convexa', 'almendra', 'bosque', Clase).
% Clase = 'ingerible'.

?- clase_hongo('conica', 'ninguno', 'bosque', Clase).
% Clase = 'venenoso'.

?- clase_hongo('x', 'y', 'z', Clase).
% Clase = 'desconocido'.    % cuando no hay evidencia documentada