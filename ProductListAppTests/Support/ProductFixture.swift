enum ProductFixture {

  static let product = """
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "A popular mascara known for its volumizing effects.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 10.48,
      "rating": 2.56,
      "stock": 99,
      "brand": "Essence",
      "sku": "BEA-ESS-ESS-001",
      "images": ["https://cdn.dummyjson.com/p/beauty/mascara/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/p/beauty/mascara/thumbnail.webp"
    }
    """

  static let productWithoutBrand = """
    {
      "id": 7,
      "title": "Chicken Meat",
      "description": "Fresh and tender chicken meat.",
      "category": "groceries",
      "price": 9.99,
      "discountPercentage": 10.46,
      "rating": 4.51,
      "stock": 65,
      "images": ["https://cdn.dummyjson.com/p/groceries/chicken/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/p/groceries/chicken/thumbnail.webp"
    }
    """

  static let listResponse = """
    {
      "products": [\(product), \(productWithoutBrand)],
      "total": 194,
      "skip": 0,
      "limit": 30
    }
    """
}
