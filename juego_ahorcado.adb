with Ada.Text_Io, nt_console, ada.Integer_Text_IO, ada.Characters.Handling, ada.Sequential_IO, ada.Numerics.Discrete_Random;
use Ada.Text_Io, nt_console, ada.Integer_Text_IO, ada.Characters.Handling;

procedure juego_ahorcado is 

   subtype rango_cad is integer range 1..40;
   subtype t_cad is string(rango_cad);

   subtype rangovec is integer range 1..50;
   
   PACKAGE Aleatorio IS NEW Ada.Numerics.Discrete_Random(rangovec); 
   use aleatorio;
   
   SUBTYPE Tipo_Nombre IS String(1..20); 
   
   TYPE Tipo_Palabra IS RECORD 
      Palabra: Tipo_Nombre; 
      Long: Integer; 
   END RECORD; 
    
   type tipovec is array(rangovec) of tipo_palabra;
   type tipovec_int is array(1..20) of integer;

   PACKAGE Archivos IS NEW Ada.Sequential_IO(Tipo_Palabra); 
   use archivos;

   cabezax: integer:= 15; cabezay: integer:= 3;
   Cuerpox: Integer:= 15; Cuerpoy: Integer:= 4; 
   Pierna_Dx: Integer:= 16; Pierna_Dy: Integer:= 5; 
   Pierna_Ix: Integer:= 14; Pierna_Iy: Integer:= 5; 
   Brazo_Dx: Integer:= 16; Brazo_Dy: Integer:= 3; 
   brazo_ix: integer:= 13; brazo_iy: integer:= 3; 



-- Moodulos
   PROCEDURE Get_Palabra(Pal: OUT Tipo_Palabra) IS 
   BEGIN 
      Get_line(Pal.Palabra, Pal.Long); 
   end get_palabra;
   


   PROCEDURE Ingresar_Vec(Vec: OUT Tipovec) IS 
      Pal_Aux: Tipo_Palabra;
   BEGIN
      for i in rangovec loop
         Put("Ingrese una palabra: "); Get_Palabra(pal_aux); vec(i):= pal_aux; New_Line; 
      end loop;
   end ingresar_vec;   



   PROCEDURE Subir_Archivo(Arch: IN OUT Archivos.File_Type; Vec: IN Tipovec) IS 
   BEGIN 
      Create(Arch, Out_File, "Datos.dat"); 
      FOR I IN rangovec LOOP 
         Write(Arch, Vec(I)); 
      END LOOP; 
      Close(Arch); 
   END Subir_Archivo;
   


   PROCEDURE Bajar_Archivo(Arch: IN OUT Archivos.File_Type; Vec: OUT Tipovec) IS 
   BEGIN 
      Open(Arch, In_File, "Datos.dat"); 
      FOR I IN rangovec LOOP 
         Read(Arch, Vec(I)); 
      END LOOP; 
      Close(Arch); 
   end bajar_archivo;   
   


   PROCEDURE Dibujar_Horca IS 
   BEGIN 
      Goto_Xy(15,2); 
      Put("|");
      Goto_Xy(15,1); 
      Put("|");
      Goto_Xy(15,0); 
      Put("_");
      Goto_Xy(16,0); 
      Put("_");
      Goto_Xy(17,0); 
      Put("_");
      Goto_Xy(18,0); 
      Put("_");
      Goto_Xy(19,0); 
      Put("_");
      Goto_Xy(20,0); 
      Put("_");
      Goto_Xy(20,1); 
      Put("|");
      Goto_Xy(20,2); 
      Put("|");
      Goto_Xy(20,3); 
      Put("|");
      Goto_Xy(20,4); 
      Put("|");
      Goto_Xy(20,5); 
      Put("|"); 
      Goto_Xy(20,6); 
      Put("|");
      Goto_Xy(18,6); 
      Put("_");
      Goto_Xy(19,6); 
      Put("_");
      Goto_Xy(20,6); 
      Put("_"); 
      Goto_Xy(21,6); 
      Put("_");
      Goto_Xy(22,6); 
      Put("_"); 
      Goto_Xy(19,1); 
      Put("\"); 
   end dibujar_horca;
   
   procedure dibujar_cabeza is
   begin
      goto_xy(Cabezax,Cabezay); 
      Put("O"); 
   end Dibujar_Cabeza; 
   
procedure dibujar_cuerpo is
begin
   Goto_Xy(Cuerpox, Cuerpoy); 
   Put("I");  
end Dibujar_Cuerpo;

procedure Dibujar_Piernad is
   begin
   Goto_Xy(Pierna_Dx, Pierna_Dy); 
   Put("\"); 
   end Dibujar_Piernad;
   
procedure dibujar_piernai is
   begin
   Goto_Xy(Pierna_Ix, Pierna_Iy); 
   Put("/");  
   end Dibujar_Piernai; 
   
procedure dibujar_brazod is
   begin
   Goto_Xy(Brazo_Dx, Brazo_Dy); 
   Put("__"); 
   end Dibujar_Brazod; 
   
procedure dibujar_brazoi is
   begin
   Goto_Xy(Brazo_Ix, Brazo_Iy); 
   Put("__"); Goto_Xy(18, 9); Skip_Line; 
   END Dibujar_Brazoi; 
   

   PROCEDURE Esta(let: character; pal: tipo_palabra; pos: in out tipovec_int; veces: out integer; encontrado: out boolean) IS 
   BEGIN 
      encontrado:= false;
      veces:= 0;
      FOR I IN 2..Pal.Long LOOP 
         IF Let = Pal.Palabra(I) THEN 
            encontrado:= true;
            Veces:= Veces+1; 
            Pos(Veces):= I; 
         end if;
      end loop;
   end esta;
   
      function no_repetida(cad: t_cad; letra: character; ult: integer) return boolean is
      rep: boolean:= true;
      begin
         for i in 1..ult-1 loop
            if letra = cad(i) then
               rep:= false; 
            end if;
         end loop;
         return rep;
      end no_repetida;

      procedure limpiar_cadena(cad: in out t_cad) is
      begin
         for i in rango_cad loop
            cad(i):= ' ';
         end loop; 
      end limpiar_cadena;
      
-----------------------------------------------------------------

-- Declaraciones

   arch: archivos.file_type;
   num: integer;
   gen: generator;
   Vec: Tipovec; -- Vector para palabras
   vec_aux: tipovec_int; -- Vector para indices
   Letra: Character;
   Perdio: Boolean:= False; Gano: Boolean:= False; 
   Control_Perdio: Integer; Control_Gano: Integer; 
   encontrado: boolean;
   Veces: Integer; 
   Aux: Integer; 
   Rta: Character:= 's';
   cant_ganadas: integer:= 0; cant_perdidas: integer:= 0;
   ultima_letra: integer; 
   cad_repetidas: t_cad; 
  
-- Programa principal 
   
begin

   bajar_archivo(arch, vec);
   Set_Foreground(Black); 

while to_lower(rta) /= 'n' loop -- Main Loop
   Clear_Screen(Gray); 
   Goto_Xy(0,23); 
   put_line("Desarrollado por Ezequiel Silvestre Corporation :') <3");      
   put("Copyright@ 2016");
   Goto_Xy(26,1); 
   put("Partidas Ganadas: ");put(cant_ganadas,0); 
   goto_xy(26,2);
   Put("Partidas Perdidas: ");Put(Cant_Perdidas,0);  
   goto_xy(26,3);
   put("Puntaje: ");put(cant_ganadas - cant_perdidas,0);   
-- Inicicializar cursor
   dibujar_horca;
   Goto_Xy(0,9); 
   
-- Generar numero random
   Reset(Gen); 
   Num:= Random(Gen); 
   
-- Imprimir base
   FOR I IN 1..vec(num).long LOOP 
      put("_ ");    
   END LOOP; 
   
-- Imprimir primera letra de palabra seleccionada
   goto_xy(0, 8);
   Put(Vec(Num).Palabra(1)); 
   
   perdio:= false; gano:= false;
   control_perdio:= 0; control_gano:= 0;
   
   limpiar_cadena(cad_repetidas); 
   ultima_letra:= 0;   

   WHILE NOT Perdio and not gano LOOP -- Loop del juego
      Goto_Xy(0,11); 
      Put("Ingrese una letra: "); 
      Get(Letra);
       
      goto_xy(19,11); set_foreground(gray); put(letra); set_foreground(black); -- Borrar de la pantalla la letra ingresada

      ultima_letra:= ultima_letra + 1; 
      cad_repetidas(ultima_letra):= letra;
      
      Esta(Letra, Vec(Num), Vec_Aux, Veces, Encontrado); 
      
      IF Encontrado and no_repetida(cad_repetidas, letra, ultima_letra) THEN 
         FOR I IN 1..Veces LOOP 
            aux:= vec_aux(i) + (vec_aux(i) - 2);
            Goto_Xy(Aux, 8); 
            Put(Letra); 
         end loop; 
         control_gano:= control_gano + veces;
      ELSE 
         Control_perdio:= Control_perdio+1; 
      END IF; 
      
      IF Control_perdio = 6 THEN 
         dibujar_cabeza;
         Perdio:= True; 
         
      ELSIF Control_Perdio = 5 THEN
         Dibujar_Cuerpo; 
         
      ELSIF Control_Perdio = 4 THEN
         dibujar_brazoi;
      
      ELSIF Control_Perdio = 3 THEN
         dibujar_brazod;
      
      ELSIF Control_Perdio = 2 THEN
         Dibujar_Piernad; 
      
      ELSIF Control_Perdio = 1 THEN 
         Dibujar_Piernai; 
      
      END IF;
         
      IF Control_Gano = (Vec(Num).Long - 1) then 
         Gano:= True;    
      end if;
   end loop;  -- Loop del juego
   
   Goto_Xy(7,13); 
   IF Gano THEN 
      Put("GANASTE"); 
      cant_ganadas:= cant_ganadas +1;    
   ELSIF Perdio THEN 
      Put("PERDISTE"); 
      cant_perdidas:= cant_perdidas +1;
   end if;

-- Imprimir Puntaje
   Goto_Xy(26,1); 
   put("Partidas Ganadas: ");put(cant_ganadas,0); 
   goto_xy(26,2);
   Put("Partidas Perdidas: ");Put(Cant_Perdidas,0);  
   goto_xy(26,3);
   put("Puntaje: ");put(cant_ganadas - cant_perdidas,0);   


   Goto_Xy(7,15); 
   put("Deseas jugar otra vez? (s/n): ");
   Get(Rta); 
   skip_line;
   end loop; -- Main Loop
end juego_ahorcado;
