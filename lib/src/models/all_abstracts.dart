/// Base class for models with name property
abstract class HasName {
  String? get name;
}

/// Base class for models with id property
abstract class HasId {
  String? get id;
}

/// Base class for models that can be selected
abstract class Selectable {
  bool get isSelected;
}

/// Base model for items with name, id and selection capability
abstract class SelectableItem implements HasName, HasId, Selectable {
  @override
  String? get name;

  @override
  String? get id;

  @override
  bool get isSelected;
}

/// Model for dropdown items
class DropdownItem implements HasName, HasId {
  @override
  final String? name;

  @override
  final String? id;

  final dynamic value;

  const DropdownItem({
    this.name,
    this.id,
    this.value,
  });
}

/// Model for chip items
class ChipItem implements HasName, HasId {
  @override
  final String? name;

  @override
  final String? id;

  final bool isSelected;

  const ChipItem({
    this.name,
    this.id,
    this.isSelected = false,
  });

  ChipItem copyWith({
    String? name,
    String? id,
    bool? isSelected,
  }) {
    return ChipItem(
      name: name ?? this.name,
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
