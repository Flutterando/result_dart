/// Used instead of `void` as a return statement for a function
/// when no value is to be returned.
///
/// There is only one value of type [Unit].
library;

sealed class Unit {
  const Unit._();
}

/// El subtipo único que permite la creación de la instancia.
/// Al ser 'final', nadie fuera de este archivo puede extenderlo.
final class _UnitImpl extends Unit {
  const _UnitImpl() : super._();
}

/// La única instancia accesible globalmente.
const Unit unit = _UnitImpl();
