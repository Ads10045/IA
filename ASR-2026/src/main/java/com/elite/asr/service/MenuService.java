package com.elite.asr.service;

import com.elite.asr.model.Product;
import java.util.ArrayList;
import java.util.List;

public class MenuService {

        public List<Product> loadProducts() {
                List<Product> products = new ArrayList<>();

                // --- FORMULES / MENUS ---
                products.add(new Product("Menu Beldi (Café + Omelette + Eau)", 45.00, "FORMULES",
                                "/images/products/menu_beldi.jpg"));
                products.add(new Product("Menu Classique (Thé + Croissant)", 25.00, "FORMULES",
                                "/images/products/menu_classique.jpg"));
                products.add(new Product("Express Matin (Café + Croissant + Jus)", 38.00, "FORMULES",
                                "/images/products/express_matin.jpg"));

                // --- PETITS-DÉJEUNERS ---
                products.add(new Product("Pancakes Sirop", 45.00, "PETIT-DÉJ",
                                "/images/products/pancakes.jpg"));
                products.add(new Product("Œufs (Scrambled)", 35.00, "PETIT-DÉJ",
                                "/images/products/oeufs.jpg"));
                products.add(new Product("Avocado Toast", 65.00, "PETIT-DÉJ",
                                "/images/products/avocado_toast.jpg"));
                products.add(new Product("Croissant", 12.00, "PETIT-DÉJ",
                                "/images/products/croissant.jpg"));
                products.add(new Product("Pain au Chocolat", 15.00, "PETIT-DÉJ",
                                "/images/products/pain_au_chocolat.jpg"));

                // --- PLATS INTERNATIONAUX ---
                products.add(new Product("Sushi Platter", 180.00, "MONDE",
                                "/images/products/sushi.jpg"));
                products.add(new Product("Maki Saumon", 85.00, "MONDE",
                                "/images/products/maki.jpg"));
                products.add(new Product("Paella Royale", 120.00, "MONDE",
                                "/images/products/paella.jpg"));
                products.add(new Product("Pad Thai", 95.00, "MONDE",
                                "/images/products/pad_thai.jpg"));

                // --- MAROCAIN ---
                products.add(new Product("Couscous Royal", 110.00, "MAROC",
                                "/images/products/couscous.jpg"));
                products.add(new Product("Tajine Kefta", 85.00, "MAROC",
                                "/images/products/tajine.jpg"));
                products.add(new Product("Pastilla Poulet", 90.00, "MAROC",
                                "/images/products/pastilla.jpg"));
                products.add(new Product("Harira & Dates", 45.00, "MAROC",
                                "/images/products/harira.jpg"));

                // --- ITALIEN ---
                products.add(new Product("Pizza Margherita", 65.00, "ITALIE",
                                "/images/products/margherita.jpg"));
                products.add(new Product("Pasta Carbonara", 85.00, "ITALIE",
                                "/images/products/carbonara.jpg"));
                products.add(new Product("Tiramisu Maison", 55.00, "ITALIE",
                                "/images/products/tiramisu.jpg"));

                // --- BURGERS ---
                products.add(new Product("Le Prestige Burger", 95.00, "BURGERS",
                                "/images/products/burger_prestige.jpg"));
                products.add(new Product("Cheeseburger Bœuf", 80.00, "BURGERS",
                                "/images/products/cheeseburger.jpg"));
                products.add(new Product("Chicken Deluxe", 75.00, "BURGERS",
                                "/images/products/chicken_deluxe.jpg"));

                // --- BOISSONS ---
                products.add(new Product("Café Espresso", 18.00, "BOISSONS",
                                "/images/products/espresso.jpg"));
                products.add(new Product("Café au Lait", 22.00, "BOISSONS",
                                "/images/products/espresso.jpg"));
                products.add(new Product("Chocolat Chaud", 30.00, "BOISSONS",
                                "/images/products/chocolat_chaud.jpg"));
                products.add(new Product("Thé à la Menthe", 15.00, "BOISSONS",
                                "/images/products/menthe.jpg"));
                products.add(new Product("Jus Orange Frais", 25.00, "BOISSONS",
                                "/images/products/jus_orange.jpg"));
                products.add(new Product("Coca-Cola / Soda", 15.00, "BOISSONS",
                                "/images/products/coca.jpg"));

                // --- DESSERTS ---
                products.add(new Product("Fondant Chocolat", 45.00, "DESSERTS",
                                "/images/products/fondant.jpg"));
                products.add(new Product("Cheesecake SB", 55.00, "DESSERTS",
                                "/images/products/cheesecake.jpg"));
                products.add(new Product("Salade de Fruits", 35.00, "DESSERTS",
                                "/images/products/fruit_salad.jpg"));
                products.add(new Product("Crème Brûlée", 50.00, "DESSERTS",
                                "/images/products/creme_brulee.jpg"));
                products.add(new Product("Mousse Chocolat", 40.00, "DESSERTS",
                                "/images/products/mousse_choc.jpg"));

                return products;
        }
}
