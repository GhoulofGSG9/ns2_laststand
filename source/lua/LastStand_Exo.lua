local exo_handlebuttons = Exo.HandleButtons
function Exo:HandleButtons(input)

    input.move:Scale(0)
    input.commands = RemoveMoveCommand( input.commands, Move.Jump )
    input.commands = RemoveMoveCommand( input.commands, Move.MovementModifier )
    
    if exo_handlebuttons then
        exo_handlebuttons(self, input)
    end

end