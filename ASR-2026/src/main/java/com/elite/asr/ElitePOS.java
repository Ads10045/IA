package com.elite.asr;

import com.elite.asr.model.OrderItem;
import com.elite.asr.model.Product;
import com.elite.asr.model.TableSession;
import com.elite.asr.service.MenuService;
import org.kordamp.ikonli.javafx.FontIcon;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.geometry.Rectangle2D;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.stage.Stage;

import java.util.*;
import java.util.stream.Collectors;

public class ElitePOS extends Application {

    // --- Services & State ---
    private final MenuService menuService = new MenuService();
    private final Map<Integer, TableSession> tables = new HashMap<>();
    private final List<Product> allProducts = new ArrayList<>();

    private TableSession currentTable;

    // --- UI Controls ---
    private StackPane rootStack;
    private BorderPane mainLayout;
    private VBox orderListContainer;
    private VBox tableListContainer;
    private Label lblSubTotal, lblTax, lblTotal, lblTableInfo;
    private TilePane productGrid;

    @Override
    public void start(Stage primaryStage) {
        allProducts.addAll(menuService.loadProducts());

        rootStack = new StackPane();

        // 1. Build Main POS Layout
        mainLayout = new BorderPane();
        mainLayout.getStyleClass().add("root-pane");
        mainLayout.setLeft(createOrderPanel());
        mainLayout.setRight(createTableListPanel());

        BorderPane productSection = new BorderPane();
        productSection.getStyleClass().add("product-section");
        productSection.setTop(createCategoryBar());
        productSection.setCenter(createProductGrid());
        mainLayout.setCenter(productSection);

        rootStack.getChildren().add(mainLayout);

        // 2. Setup Scene
        Scene scene = new Scene(rootStack, 1280, 800);
        try {
            String css = Objects.requireNonNull(getClass().getResource("/styles/theme.css")).toExternalForm();
            scene.getStylesheets().add(css);
        } catch (Exception e) {
        }

        primaryStage.setTitle("ASR-2026 - Le Prestige");
        primaryStage.setScene(scene);
        primaryStage.show();

        // 4. Initial State
        String initialCat = getAutoCategory();
        filterProducts(initialCat);
        showKeypadFlow(true, 0); // Prompt at startup
        refreshTableListView();
    }

    // ==========================================
    // KEYPAD LOGIC
    // ==========================================

    private void showKeypadFlow(boolean isTableStep, int tableIdIfKnown) {
        VBox overlay = new VBox();
        overlay.setAlignment(Pos.CENTER);
        overlay.setStyle("-fx-background-color: rgba(0,0,0,0.8);"); // Dark semi-transparent background

        VBox keypadCard = new VBox(30);
        keypadCard.setAlignment(Pos.CENTER);
        keypadCard.setPadding(new Insets(40));
        keypadCard.setMaxWidth(600);
        keypadCard.setStyle(
                "-fx-background-color: #ffffff; -fx-background-radius: 40; -fx-effect: dropshadow(three-pass-box, rgba(0,0,0,0.3), 30, 0, 0, 0);");

        // --- STEP ICON & TITLE ---
        HBox titleContainer = new HBox(20);
        titleContainer.setAlignment(Pos.CENTER);

        FontIcon mainIcon = new FontIcon(isTableStep ? "fas-chair" : "fas-users");
        mainIcon.setIconSize(70);
        mainIcon.setIconColor(javafx.scene.paint.Color.valueOf("#D32F2F"));

        VBox textTitle = new VBox(0);
        Label stepTitle = new Label(isTableStep ? "SÉLECTION DE TABLE" : "NOMBRE DE CLIENTS");
        stepTitle.setStyle("-fx-font-size: 32px; -fx-font-weight: 900; -fx-text-fill: #212121;");
        Label stepSubtitle = new Label(isTableStep ? "ENTREZ LE NUMÉRO DE LA TABLE" : "ENTREZ LE NOMBRE DE COUVERTS");
        stepSubtitle.setStyle("-fx-font-size: 14px; -fx-text-fill: #757575; -fx-font-weight: bold;");
        textTitle.getChildren().addAll(stepTitle, stepSubtitle);

        titleContainer.getChildren().addAll(mainIcon, textTitle);

        if (!isTableStep) {
            Label tableLabel = new Label("POUR TABLE #" + tableIdIfKnown);
            tableLabel.setStyle(
                    "-fx-font-size: 18px; -fx-font-weight: bold; -fx-text-fill: #D32F2F; -fx-background-color: #fdf2f2; -fx-padding: 8 15; -fx-background-radius: 10;");
            titleContainer.getChildren().add(tableLabel);
        }

        Button btnBackKeypad = new Button();
        btnBackKeypad.setGraphic(new FontIcon("fas-times"));
        btnBackKeypad.setStyle("-fx-background-color: transparent; -fx-text-fill: #999; -fx-cursor: hand;");
        btnBackKeypad.setOnAction(e -> rootStack.getChildren().remove(overlay));

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);
        titleContainer.getChildren().addAll(spacer, btnBackKeypad);

        // --- DISPLAY AREA ---
        HBox displayWrapper = new HBox(15);
        displayWrapper.setAlignment(Pos.CENTER);
        displayWrapper.setMaxWidth(400);
        displayWrapper.setStyle("-fx-background-color: #f8f9fa; -fx-background-radius: 25; -fx-padding: 15 40; " +
                "-fx-border-color: #eee; -fx-border-width: 1; -fx-border-radius: 25;");

        FontIcon hashIcon = new FontIcon("fas-hashtag");
        hashIcon.setIconSize(30);
        hashIcon.setIconColor(javafx.scene.paint.Color.valueOf("#D32F2F"));

        Label displayLabel = new Label("");
        displayLabel.setStyle("-fx-font-size: 60px; -fx-font-weight: 900; -fx-text-fill: #212121;");

        displayWrapper.getChildren().addAll(hashIcon, displayLabel);

        // --- KEYPAD GRID ---
        GridPane pad = new GridPane();
        pad.setHgap(15);
        pad.setVgap(15);
        pad.setAlignment(Pos.CENTER);

        String[] buttons = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "OK" };
        for (int i = 0; i < buttons.length; i++) {
            String bText = buttons[i];
            Button b = new Button();
            b.setPrefSize(95, 95);

            String baseStyle = "-fx-font-size: 30px; -fx-font-weight: 900; -fx-background-radius: 25; -fx-cursor: hand;";

            if (bText.equals("OK")) {
                b.setText("OK");
                b.setStyle(baseStyle + "-fx-background-color: #D32F2F; -fx-text-fill: white; -fx-font-size: 24px;");
            } else if (bText.equals("C")) {
                b.setGraphic(new FontIcon("fas-backspace"));
                ((FontIcon) b.getGraphic()).setIconSize(28);
                ((FontIcon) b.getGraphic()).setIconColor(javafx.scene.paint.Color.WHITE);
                b.setStyle(baseStyle + "-fx-background-color: #424242;");
            } else {
                Node icon = getDigitIcon(bText);
                if (icon != null) {
                    ((ImageView) icon).setFitHeight(55);
                    b.setGraphic(icon);
                } else
                    b.setText(bText);
                b.setStyle(baseStyle + "-fx-background-color: white; -fx-border-color: #eceff1; -fx-border-width: 2;");
            }

            b.setOnAction(e -> {
                if (bText.equals("C")) {
                    displayLabel.setText("");
                } else if (bText.equals("OK")) {
                    if (!displayLabel.getText().isEmpty()) {
                        int val = Integer.parseInt(displayLabel.getText());
                        rootStack.getChildren().remove(overlay);
                        if (isTableStep) {
                            if (tables.containsKey(val)) {
                                switchTable(tables.get(val));
                            } else {
                                showKeypadFlow(false, val);
                            }
                        } else {
                            TableSession newTable = new TableSession(tableIdIfKnown, val);
                            tables.put(tableIdIfKnown, newTable);
                            switchTable(newTable);
                        }
                    }
                } else {
                    if (displayLabel.getText().length() < 3)
                        displayLabel.setText(displayLabel.getText() + bText);
                }
            });
            pad.add(b, i % 3, i / 3);
        }

        keypadCard.getChildren().addAll(titleContainer, displayWrapper, pad);

        if (!isTableStep) {
            HBox quickClients = new HBox(10);
            quickClients.setAlignment(Pos.CENTER);
            for (int i = 1; i <= 6; i++) {
                String q = String.valueOf(i);
                Button qb = new Button(q);
                qb.setPrefSize(65, 65);
                qb.setStyle(
                        "-fx-background-color: white; -fx-border-color: #D32F2F; -fx-border-radius: 15; -fx-background-radius: 15; "
                                +
                                "-fx-text-fill: #D32F2F; -fx-font-weight: 900; -fx-font-size: 20px; -fx-cursor: hand;");
                qb.setOnAction(e -> {
                    TableSession newTable = new TableSession(tableIdIfKnown, Integer.parseInt(q));
                    tables.put(tableIdIfKnown, newTable);
                    rootStack.getChildren().remove(overlay);
                    switchTable(newTable);
                });
                quickClients.getChildren().add(qb);
            }
            keypadCard.getChildren().add(quickClients);
        }

        overlay.getChildren().add(keypadCard);
        rootStack.getChildren().add(overlay);
    }

    // ==========================================
    // LOGIC
    // ==========================================

    private void switchTable(TableSession table) {
        this.currentTable = table;
        refreshOrderView();
        updateTableInfoDisplay();
        refreshTableListView();
    }

    private void updateTableInfoDisplay() {
        if (currentTable != null) {
            lblTableInfo.setText("Table " + currentTable.getTableId() + " (" + currentTable.getClients() + " pers.)");
        } else {
            lblTableInfo.setText("Choisir Table");
        }
    }

    private void addProductToOrder(Product p) {
        addProductToOrder(p, null, null);
    }

    private void refreshOrderView() {
        orderListContainer.getChildren().clear();
        if (currentTable == null) {
            resetTotals();
            return;
        }
        double total = 0;
        for (OrderItem item : currentTable.getOrderItems()) {
            orderListContainer.getChildren().add(createOrderItemRow(item));
            total += item.getPrice() * item.getQuantity();
        }
        updateTotals(total);
    }

    private void refreshTableListView() {
        if (tableListContainer == null)
            return;
        tableListContainer.getChildren().clear();
        for (TableSession t : tables.values()) {
            VBox card = new VBox(8);
            card.setPadding(new Insets(12));
            if (t == currentTable)
                card.setStyle(
                        "-fx-background-color: #fdf2f2; -fx-border-color: #D32F2F; -fx-border-width: 2; -fx-border-radius: 8px; -fx-background-radius: 8px;");
            else
                card.setStyle(
                        "-fx-background-color: white; -fx-border-color: #ddd; -fx-border-width: 1; -fx-border-radius: 8px; -fx-background-radius: 8px;");

            card.setCursor(javafx.scene.Cursor.HAND);
            card.setOnMouseClicked(e -> switchTable(t));

            HBox header = new HBox(10);
            header.setAlignment(Pos.CENTER_LEFT);
            FontIcon chairIcon = new FontIcon("fas-chair");
            chairIcon.setIconSize(16);
            Label tableNum = new Label("TABLE " + t.getTableId());
            tableNum.setStyle("-fx-font-weight: bold; -fx-font-size: 14px;");
            header.getChildren().addAll(chairIcon, tableNum);

            double total = t.getOrderItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
            Label amount = new Label(String.format("%.2f DH", total));
            amount.setStyle("-fx-font-weight: bold; -fx-text-fill: #D32F2F; -fx-font-size: 16px;");

            HBox clientInfo = new HBox(5);
            clientInfo.setAlignment(Pos.CENTER_LEFT);
            FontIcon usersIcon = new FontIcon("fas-users");
            usersIcon.setIconSize(12);
            Label clients = new Label(t.getClients() + " pers.");
            clients.setStyle("-fx-text-fill: #666; -fx-font-size: 11px;");
            clientInfo.getChildren().addAll(usersIcon, clients);

            card.getChildren().addAll(header, amount, clientInfo);
            tableListContainer.getChildren().add(card);
        }
    }

    private void updateTotals(double total) {
        double tax = total * 0.20;
        double subTotal = total - tax;
        lblSubTotal.setText(String.format("%.2f DH", subTotal));
        lblTax.setText(String.format("%.2f DH", tax));
        lblTotal.setText(String.format("%.2f DH", total));
    }

    private void resetTotals() {
        updateTotals(0.0);
    }

    private void filterProducts(String category) {
        productGrid.getChildren().clear();
        List<Product> filtered = category.equals("TOUT") ? allProducts
                : allProducts.stream().filter(p -> p.getCategory().equals(category)).collect(Collectors.toList());
        for (Product p : filtered)
            productGrid.getChildren().add(createProductCard(p));
    }

    // ==========================================
    // UI BUILDERS
    // ==========================================

    private Image digitsImage;

    private Node getDigitIcon(String text) {
        try {
            if (digitsImage == null) {
                digitsImage = new Image(getClass().getResourceAsStream("/images/digits.png"));
            }
            int n = Integer.parseInt(text);
            ImageView iv = new ImageView(digitsImage);
            int col = n % 5;
            int row = n < 5 ? 0 : 1;
            // The image layout is 0 1 2 3 4 in row 0 and 5 6 7 8 9 in row 1
            iv.setViewport(new Rectangle2D(col * 100, row * 140, 100, 140));
            iv.setFitHeight(60);
            iv.setPreserveRatio(true);
            return iv;
        } catch (Exception e) {
            return null;
        }
    }

    private VBox createOrderPanel() {
        VBox panel = new VBox();
        panel.getStyleClass().add("order-panel");
        panel.setPrefWidth(380);

        // --- THE RECEIPT PAPER ---
        VBox invoicePaper = new VBox(0);
        invoicePaper.getStyleClass().add("invoice-paper");

        // Receipt Header
        VBox receiptHeader = new VBox(2);
        receiptHeader.getStyleClass().add("invoice-header");
        receiptHeader.setAlignment(Pos.CENTER);

        Label sysTitle = new Label("ASR-2026 - LE PRESTIGE");
        sysTitle.getStyleClass().add("invoice-title");

        Label sysSubtitle = new Label("RÉSIDENCE LE PRESTIGE, CASABLANCA");
        sysSubtitle.getStyleClass().add("invoice-subtitle");

        Label sysTel = new Label("TÉL: +212 5 22 00 11 22");
        sysTel.getStyleClass().add("invoice-subtitle");

        receiptHeader.getChildren().addAll(sysTitle, sysSubtitle, sysTel);

        // Current Table Info
        lblTableInfo = new Label("CHOISIR TABLE");
        lblTableInfo.setStyle("-fx-font-weight: bold; -fx-padding: 10 0; -fx-text-fill: #000;");

        // List of Items
        orderListContainer = new VBox(2);
        ScrollPane scrollList = new ScrollPane(orderListContainer);
        scrollList.setFitToWidth(true);
        scrollList.setStyle("-fx-background: #FFFFFF; -fx-background-color: transparent; -fx-padding: 10 0;");
        VBox.setVgrow(scrollList, Priority.ALWAYS);

        // Totals Area
        lblSubTotal = new Label("0.00 DH");
        lblTax = new Label("0.00 DH");
        lblTotal = new Label("0.00 DH");
        VBox totalsBox = new VBox(2);
        totalsBox.getStyleClass().add("totals-box");
        totalsBox.getChildren().addAll(
                createTotalRow("SOUS-TOTAL", lblSubTotal, false),
                createTotalRow("TVA (20%)", lblTax, false),
                createTotalRow("TOTAL TTC", lblTotal, true));

        // Footer note
        Label footerNote = new Label("MERCI DE VOTRE VISITE !");
        footerNote.setStyle("-fx-font-size: 10px; -fx-padding: 10 0;");
        footerNote.setAlignment(Pos.CENTER);

        invoicePaper.getChildren().addAll(receiptHeader, lblTableInfo, scrollList, totalsBox, footerNote);
        VBox.setVgrow(invoicePaper, Priority.ALWAYS);

        // --- ACTION BUTTONS (Outside Paper) ---
        Button payBtn = new Button("ENCAISSER & IMPRIMER");
        payBtn.getStyleClass().addAll("button", "btn-primary");
        payBtn.setMaxWidth(Double.MAX_VALUE);
        payBtn.setPrefHeight(60);
        payBtn.setOnMouseClicked(e -> handlePayment());

        VBox actionBox = new VBox(payBtn);
        actionBox.setPadding(new Insets(10, 20, 0, 20));

        panel.getChildren().addAll(invoicePaper, actionBox);
        return panel;
    }

    private VBox createTableListPanel() {
        VBox panel = new VBox(15);
        panel.getStyleClass().add("order-panel");
        panel.setPrefWidth(220);
        Label title = new Label("Tables");
        title.getStyleClass().add("h2");

        Button addTableBtn = new Button(" Nouvelle Table");
        addTableBtn.setGraphic(new FontIcon("fas-plus-circle"));
        addTableBtn.setMaxWidth(Double.MAX_VALUE);
        addTableBtn.getStyleClass().add("btn-primary");
        addTableBtn.setOnAction(e -> showKeypadFlow(true, 0));

        tableListContainer = new VBox(10);
        ScrollPane scroll = new ScrollPane(tableListContainer);
        scroll.setFitToWidth(true);
        VBox.setVgrow(scroll, Priority.ALWAYS);
        panel.setPadding(new Insets(20, 10, 20, 10));
        panel.getChildren().addAll(title, addTableBtn, scroll);
        return panel;
    }

    private void handlePayment() {
        if (currentTable != null) {
            showPaymentOverlay(currentTable);
        }
    }

    private void showPaymentOverlay(TableSession table) {
        double totalToPay = table.getOrderItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();

        HBox mainContainer = new HBox(0);
        mainContainer.setAlignment(Pos.CENTER);
        mainContainer.setStyle("-fx-background-color: rgba(0,0,0,0.85);");

        Label changeDisplay = new Label("0.00 DH");
        changeDisplay.setStyle("-fx-font-size: 22px; -fx-font-weight: 900; -fx-text-fill: #2E7D32;");

        // --- LEFT SIDE: THE RECEIPT ---
        VBox leftSection = new VBox(20);
        leftSection.setAlignment(Pos.CENTER);
        leftSection.setPadding(new Insets(40));
        leftSection.setPrefWidth(450);

        Label receiptTitle = new Label("FACTURE CLIENT");
        receiptTitle.setStyle("-fx-text-fill: white; -fx-font-size: 20px; -fx-font-weight: bold;");

        Button btnBack = new Button();
        btnBack.setGraphic(new FontIcon("fas-arrow-left"));
        btnBack.setStyle("-fx-background-color: transparent; -fx-text-fill: white; -fx-cursor: hand;");
        btnBack.setOnAction(e -> rootStack.getChildren().remove(mainContainer));

        HBox topBar = new HBox(20, btnBack, receiptTitle);
        topBar.setAlignment(Pos.CENTER_LEFT);

        VBox paper = new VBox(10);
        paper.getStyleClass().add("invoice-paper");
        paper.setStyle(paper.getStyle() + "-fx-pref-width: 350; -fx-min-height: 550;");

        VBox header = new VBox(2);
        header.getStyleClass().add("invoice-header");
        header.setAlignment(Pos.CENTER);
        header.getChildren().addAll(
                new Label("ASR-2026 - LE PRESTIGE"),
                new Label("RÉSIDENCE LE PRESTIGE, CASABLANCA"));
        header.getChildren().forEach(n -> {
            if (n instanceof Label)
                ((Label) n).setStyle("-fx-font-size: 11px; -fx-font-weight: bold;");
        });

        VBox itemsBox = new VBox(5);
        for (OrderItem item : table.getOrderItems()) {
            HBox row = new HBox(5);
            Label qty = new Label(item.getQuantity() + "x");
            qty.setPrefWidth(30);
            Label name = new Label(item.getName());
            HBox.setHgrow(name, Priority.ALWAYS);
            Label price = new Label(String.format("%.2f", item.getPrice() * item.getQuantity()));
            row.getChildren().addAll(qty, name, price);
            row.setStyle("-fx-font-size: 12px;");
            itemsBox.getChildren().add(row);
        }

        VBox totals = new VBox(5);
        totals.getChildren().addAll(
                new Separator(),
                createStaticTotalRow("SOUS-TOTAL", String.format("%.2f DH", totalToPay * 0.8)),
                createStaticTotalRow("TVA (20%)", String.format("%.2f DH", totalToPay * 0.2)),
                createStaticTotalRow("TOTAL TTC", String.format("%.2f DH", totalToPay)),
                new Separator(),
                new HBox(new Label("RENDU"), new Region(), changeDisplay));
        ((HBox) totals.getChildren().get(totals.getChildren().size() - 1)).setAlignment(Pos.CENTER_LEFT);
        HBox.setHgrow(((HBox) totals.getChildren().get(totals.getChildren().size() - 1)).getChildren().get(1),
                Priority.ALWAYS);
        ((Label) ((HBox) totals.getChildren().get(totals.getChildren().size() - 1)).getChildren().get(0))
                .setStyle("-fx-font-weight: bold; -fx-font-size: 16px;");

        paper.getChildren().addAll(header, new Label("TABLE " + table.getTableId()), new Separator(), itemsBox, totals);
        leftSection.getChildren().addAll(topBar, paper);

        // --- RIGHT SIDE: PAYMENT CONTROLS ---
        VBox rightSection = new VBox(30);
        rightSection.setAlignment(Pos.CENTER);
        rightSection.setPadding(new Insets(40));
        rightSection.setStyle("-fx-background-color: white; -fx-background-radius: 40 0 0 40;");
        HBox.setHgrow(rightSection, Priority.ALWAYS);

        Label payTitle = new Label("PAIEMENT");
        payTitle.setStyle("-fx-font-size: 36px; -fx-font-weight: 900; -fx-text-fill: #212121;");

        HBox amounts = new HBox(40);
        amounts.setAlignment(Pos.CENTER);

        VBox totalBox = new VBox(5, new Label("À PAYER"), new Label(String.format("%.2f DH", totalToPay)));
        totalBox.setAlignment(Pos.CENTER);
        totalBox.getChildren().get(1).setStyle("-fx-font-size: 34px; -fx-font-weight: 900; -fx-text-fill: #D32F2F;");

        VBox cashBox = new VBox(5, new Label("CASH REÇU"), new Label("0.00 DH"));
        cashBox.setAlignment(Pos.CENTER);
        Label cashDisplay = (Label) cashBox.getChildren().get(1);
        cashDisplay.setStyle(
                "-fx-font-size: 34px; -fx-font-weight: 900; -fx-background-color: #f5f5f5; -fx-padding: 10 25; -fx-background-radius: 20;");

        amounts.getChildren().addAll(totalBox, cashBox);

        GridPane keypad = new GridPane();
        keypad.setHgap(15);
        keypad.setVgap(15);
        keypad.setAlignment(Pos.CENTER);
        StringBuilder input = new StringBuilder();

        String[] keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "C", "0", "." };
        final double[] recVal = { 0.0 };

        for (int i = 0; i < keys.length; i++) {
            String k = keys[i];
            Button b = new Button();
            b.setPrefSize(95, 95);
            String kStyle = "-fx-background-radius: 25; -fx-background-color: #fff; -fx-border-color: #eee; -fx-border-width: 2; -fx-border-radius: 25; -fx-cursor: hand;";

            if (k.equals("C")) {
                b.setGraphic(new FontIcon("fas-backspace"));
                ((FontIcon) b.getGraphic()).setIconSize(24);
                b.setStyle(kStyle + "-fx-background-color: #fce4ec; -fx-border-color: #f8bbd0;");
            } else if (k.equals(".")) {
                b.setText(".");
                b.setStyle(kStyle + "-fx-font-size: 26px; -fx-font-weight: 900;");
            } else {
                Node icon = getDigitIcon(k);
                if (icon != null) {
                    ((ImageView) icon).setFitHeight(50);
                    b.setGraphic(icon);
                } else
                    b.setText(k);
                b.setStyle(kStyle);
            }

            b.setOnAction(e -> {
                if (k.equals("C"))
                    input.setLength(0);
                else if (input.length() < 8) {
                    if (k.equals(".") && input.toString().contains(".")) {
                        // ignore second dot
                    } else {
                        input.append(k);
                    }
                }

                recVal[0] = input.length() > 0 ? Double.parseDouble(input.toString()) : 0;
                cashDisplay.setText(String.format("%.2f DH", recVal[0]));
                cashDisplay.setStyle(cashDisplay.getStyle() + "-fx-text-fill: #212121;"); // Reset color
                changeDisplay.setText(String.format("%.2f DH", Math.max(0, recVal[0] - totalToPay)));
            });
            keypad.add(b, i % 3, i / 3);
        }

        HBox actions = new HBox(20);
        actions.setAlignment(Pos.CENTER);

        Button btnCash = new Button("ESPÈCES");
        btnCash.getStyleClass().add("btn-primary");
        btnCash.setPrefSize(180, 75);
        btnCash.setStyle(btnCash.getStyle() + "-fx-font-size: 18px; -fx-font-weight: 900;");

        Button btnCard = new Button("CARTE");
        btnCard.setPrefSize(180, 75);
        btnCard.setStyle(
                "-fx-background-color: #263238; -fx-text-fill: white; -fx-font-weight: 900; -fx-background-radius: 15; -fx-font-size: 18px;");

        Button btnPay = new Button("ENCAISSER");
        btnPay.setPrefSize(180, 75);
        btnPay.setStyle(
                "-fx-background-color: #2E7D32; -fx-text-fill: white; -fx-background-radius: 15; -fx-font-weight: 900; -fx-font-size: 18px;");

        Runnable checkAndPay = () -> {
            if (recVal[0] >= totalToPay - 0.01) { // Floating point safety
                finalizePayment(table, mainContainer);
            } else {
                cashDisplay.setStyle(cashDisplay.getStyle() + "-fx-text-fill: #D32F2F;");
                // Optional: add a shake animation or tooltip
            }
        };

        btnPay.setOnAction(e -> checkAndPay.run());
        btnCash.setOnAction(e -> checkAndPay.run());
        btnCard.setOnAction(e -> finalizePayment(table, mainContainer));

        Button btnBackToItems = new Button("RETOUR");
        btnBackToItems.setPrefSize(120, 75);
        btnBackToItems.setStyle(
                "-fx-background-color: #eceff1; -fx-background-radius: 15; -fx-font-weight: 900; -fx-text-fill: #37474f;");
        btnBackToItems.setOnAction(e -> rootStack.getChildren().remove(mainContainer));

        actions.getChildren().addAll(btnCash, btnCard, btnPay, btnBackToItems);
        rightSection.getChildren().addAll(payTitle, amounts, keypad, actions);

        mainContainer.getChildren().addAll(leftSection, rightSection);
        rootStack.getChildren().add(mainContainer);
    }

    private HBox createStaticTotalRow(String label, String value) {
        HBox row = new HBox();
        Label l = new Label(label);
        Label v = new Label(value);
        Region r = new Region();
        HBox.setHgrow(r, Priority.ALWAYS);
        row.getChildren().addAll(l, r, v);
        if (label.equals("TOTAL TTC"))
            row.setStyle("-fx-font-weight: bold; -fx-font-size: 14px;");
        return row;
    }

    private void finalizePayment(TableSession table, Pane overlay) {
        tables.remove(table.getTableId());
        if (currentTable == table)
            currentTable = null;
        rootStack.getChildren().remove(overlay);
        refreshOrderView();
        updateTableInfoDisplay();
        refreshTableListView();
        // showKeypadFlow(true, 0); // Removed as per user request to stay on product
        // grid
    }

    private ScrollPane createProductGrid() {
        productGrid = new TilePane();
        productGrid.getStyleClass().add("product-grid");
        productGrid.setHgap(15);
        productGrid.setVgap(15);
        productGrid.setPrefColumns(3);
        ScrollPane scroll = new ScrollPane(productGrid);
        scroll.setFitToWidth(true);
        return scroll;
    }

    private String getAutoCategory() {
        int hour = java.time.LocalTime.now().getHour();
        return (hour >= 6 && hour < 12) ? "FORMULES" : "TOUT";
    }

    private HBox createCategoryBar() {
        HBox bar = new HBox(8);
        bar.getStyleClass().add("category-bar");

        // Define categories based on time
        String[] allCats = { "TOUT", "FORMULES", "PETIT-DÉJ", "ITALIE", "MAROC", "MONDE", "BURGERS", "BOISSONS",
                "DESSERTS" };
        String[] morningCats = { "FORMULES", "BOISSONS", "PETIT-DÉJ" };

        int hour = java.time.LocalTime.now().getHour();
        boolean isMorning = (hour >= 6 && hour < 12);
        String[] catsToShow = isMorning ? morningCats : allCats;

        String initial = getAutoCategory();
        ToggleGroup group = new ToggleGroup();
        for (String cat : catsToShow) {
            ToggleButton btn = new ToggleButton(cat);
            btn.getStyleClass().add("category-btn");
            btn.setToggleGroup(group);
            if (cat.equals(initial))
                btn.setSelected(true);
            btn.setOnAction(e -> filterProducts(cat));
            bar.getChildren().add(btn);
        }
        return bar;
    }

    private HBox createOrderItemRow(OrderItem item) {
        VBox itemLines = new VBox(0);
        itemLines.setMaxWidth(Double.MAX_VALUE);
        HBox.setHgrow(itemLines, Priority.ALWAYS);

        Label nameLbl = new Label(item.getName());
        nameLbl.setStyle("-fx-font-size: 14px; -fx-font-weight: bold; -fx-text-fill: #263238;");
        itemLines.getChildren().add(nameLbl);

        if (item.getComponents() != null && !item.getComponents().isEmpty()) {
            VBox compBox = new VBox(2);
            compBox.setPadding(new Insets(2, 0, 5, 15));
            for (String comp : item.getComponents()) {
                Label cl = new Label("• " + comp);
                cl.setStyle("-fx-font-size: 11px; -fx-text-fill: #78909c; -fx-font-style: italic;");
                compBox.getChildren().add(cl);
            }
            itemLines.getChildren().add(compBox);
        }

        HBox row = new HBox(10);
        row.getStyleClass().add("order-item");
        row.setAlignment(Pos.TOP_LEFT);
        row.setPadding(new Insets(8, 0, 8, 0));

        Label qtyLbl = new Label(item.getQuantity() + "x");
        qtyLbl.setPrefWidth(35);
        qtyLbl.setStyle("-fx-font-weight: 900; -fx-font-size: 14px; -fx-text-fill: #D32F2F;");

        Label priceLbl = new Label(String.format("%.2f", item.getPrice() * item.getQuantity()));
        priceLbl.setPrefWidth(70);
        priceLbl.setAlignment(Pos.CENTER_RIGHT);
        priceLbl.setStyle("-fx-font-size: 14px; -fx-font-weight: 900; -fx-text-fill: #263238;");

        Button delBtn = new Button();
        delBtn.setGraphic(new FontIcon("fas-trash-alt"));
        delBtn.setStyle("-fx-background-color: transparent; -fx-text-fill: #cfd8dc; -fx-cursor: hand;");
        delBtn.setOnMouseEntered(
                e -> delBtn.setStyle("-fx-background-color: transparent; -fx-text-fill: #D32F2F; -fx-cursor: hand;"));
        delBtn.setOnMouseExited(
                e -> delBtn.setStyle("-fx-background-color: transparent; -fx-text-fill: #cfd8dc; -fx-cursor: hand;"));
        delBtn.setOnAction(e -> {
            if (currentTable != null) {
                currentTable.getOrderItems().remove(item);
                refreshOrderView();
                refreshTableListView();
            }
        });

        row.getChildren().addAll(qtyLbl, itemLines, priceLbl, delBtn);
        return row;
    }

    private void addProductToOrder(Product p, String nameOverride, java.util.List<String> components) {
        if (currentTable == null) {
            showKeypadFlow(true, 0);
            return;
        }
        String finalName = (nameOverride != null) ? nameOverride : p.getName();

        // Check grouping: same name AND same components
        java.util.Optional<OrderItem> existing = currentTable.getOrderItems().stream()
                .filter(item -> item.getName().equals(finalName) &&
                        ((components == null && item.getComponents().isEmpty()) ||
                                (components != null && components.equals(item.getComponents()))))
                .findFirst();

        if (existing.isPresent()) {
            existing.get().incrementQuantity();
        } else {
            java.util.List<String> compCopy = components != null ? new java.util.ArrayList<>(components)
                    : new java.util.ArrayList<>();
            currentTable.getOrderItems().add(new OrderItem(finalName, p.getPrice(), 1, compCopy));
        }

        refreshOrderView();
        refreshTableListView();
    }

    private VBox createProductCard(Product p) {
        VBox card = new VBox(5);
        card.getStyleClass().add("product-card");
        StackPane img = new StackPane();
        img.setPrefHeight(120);
        img.setStyle("-fx-background-color: #f0f0f0; -fx-background-radius: 8px;"); // Fallback

        try {
            String path = p.getImagePath();
            String finalUrl;
            if (path.startsWith("http")) {
                finalUrl = path;
            } else {
                finalUrl = Objects.requireNonNull(getClass().getResource(path)).toExternalForm();
            }
            img.setStyle(img.getStyle() + String.format(
                    "-fx-background-image: url('%s'); -fx-background-size: cover; -fx-background-position: center; -fx-background-radius: 8px;",
                    finalUrl));
        } catch (Exception e) {
            System.err.println("Could not load image: " + p.getImagePath());
        }
        Label name = new Label(p.getName());
        name.getStyleClass().add("product-name");
        Label price = new Label(String.format("%.2f DH", p.getPrice()));
        price.getStyleClass().add("product-price");
        card.getChildren().addAll(img, name, price);
        card.setOnMouseClicked(e -> {
            if (p.getCategory().equals("FORMULES")) {
                showFormuleOptions(p);
            } else {
                addProductToOrder(p, null, null);
            }
        });
        return card;
    }

    private void showFormuleOptions(Product p) {
        VBox overlay = new VBox(0);
        overlay.setAlignment(Pos.CENTER);
        overlay.setStyle("-fx-background-color: rgba(0,0,0,0.85);");

        VBox container = new VBox(20);
        container.setAlignment(Pos.TOP_CENTER);
        container.setPadding(new Insets(25));
        container.setMaxWidth(1000);
        container.setPrefHeight(800);
        container.setStyle("-fx-background-color: #f8f9fa; -fx-background-radius: 30;");

        Label title = new Label("COMPOSITION : " + p.getName().toUpperCase());
        title.setStyle("-fx-font-size: 26px; -fx-font-weight: 900; -fx-text-fill: #212121;");

        VBox stepsContainer = new VBox(25);
        stepsContainer.setAlignment(Pos.CENTER);
        stepsContainer.setPadding(new Insets(10));

        final String[] selections = { "Café", "Jus Orange", "Omelette", "Croissant", "Sans" };

        Label summaryLabel = new Label("");
        updateFormuleLabel(summaryLabel, selections);
        summaryLabel.setStyle(
                "-fx-font-size: 15px; -fx-font-weight: bold; -fx-text-fill: #D32F2F; -fx-padding: 12; -fx-background-color: #fff; -fx-background-radius: 12; -fx-border-color: #eee; -fx-border-radius: 12;");

        // Step 1: Boissons Chaudes
        VBox step1 = createStepContainer("1. BOISSON CHAUDE", new String[][] {
                { "Café", "/images/options/cafe.jpg" },
                { "Thé", "/images/options/the.jpg" },
                { "Infusion", "/images/options/infusion.jpg" },
                { "Lait", "/images/options/lait.jpg" },
                { "Chocolat", "/images/options/chocolat.jpg" },
                { "Sans", "/images/options/rien.jpg" }
        }, name -> {
            selections[0] = name;
            updateFormuleLabel(summaryLabel, selections);
        });

        // Step 2: Jus Frais
        VBox step2 = createStepContainer("2. JUS FRAIS", new String[][] {
                { "Jus Orange", "/images/options/jus.jpg" },
                { "Jus Citron", "/images/options/jus_citron.jpg" },
                { "Jus Banane", "/images/options/jus_banane.jpg" },
                { "Sans", "/images/options/rien.jpg" }
        }, name -> {
            selections[1] = name;
            updateFormuleLabel(summaryLabel, selections);
        });

        // Step 3: Plat
        VBox step3 = createStepContainer("3. PLAT PRINCIPAL", new String[][] {
                { "Omelette", "/images/options/omelette.jpg" },
                { "Pizza Maroc", "/images/options/pizza.jpg" },
                { "Pancakes", "/images/options/pancakes.jpg" },
                { "Avocado Toast", "/images/options/avocado.jpg" }
        }, name -> {
            selections[2] = name;
            updateFormuleLabel(summaryLabel, selections);
        });

        // Step 4: Boulangerie
        VBox step4 = createStepContainer("4. BOULANGERIE", new String[][] {
                { "Croissant", "/images/options/croissant.jpg" },
                { "Pain Choc", "/images/options/pain_choc.jpg" },
                { "Petit Pain", "/images/options/petit_pain.jpg" }
        }, name -> {
            selections[3] = name;
            updateFormuleLabel(summaryLabel, selections);
        });

        // Step 5: Accompagnement (Multi-selection)
        final java.util.List<String> step5List = new java.util.ArrayList<>();
        VBox step5 = createMultiStepContainer("5. ACCOMPAGNEMENTS (MULTI)", new String[][] {
                { "Huile Olive", "/images/options/huile.jpg" },
                { "Fromage", "/images/options/fromage.jpg" },
                { "Olives", "/images/options/olives.jpg" },
                { "Confiture", "/images/options/confiture.jpg" },
                { "Miel", "/images/options/miel.jpg" }
        }, selectedList -> {
            selections[4] = String.join(", ", selectedList);
            updateFormuleLabel(summaryLabel, selections);
        });

        HBox actions = new HBox(20);
        actions.setAlignment(Pos.CENTER);

        Button btnAdd = new Button("AJOUTER À LA COMMANDE");
        btnAdd.getStyleClass().addAll("button", "btn-primary");
        btnAdd.setPrefSize(350, 65);
        btnAdd.setStyle(btnAdd.getStyle() + "-fx-font-size: 18px; -fx-font-weight: 900;");
        btnAdd.setOnAction(e -> {
            java.util.List<String> components = new java.util.ArrayList<>();
            // Collect all selected components
            if (!selections[0].equals("Sans"))
                components.add(selections[0]);
            if (!selections[1].equals("Sans"))
                components.add(selections[1]);
            if (!selections[2].equals("Sans"))
                components.add(selections[2]);
            if (!selections[3].equals("Sans"))
                components.add(selections[3]);
            if (selections[4] != null && !selections[4].isEmpty()) {
                for (String extra : selections[4].split(", ")) {
                    if (!extra.isEmpty())
                        components.add(extra);
                }
            }

            addProductToOrder(p, p.getName().split("\\(")[0].trim(), components);
            rootStack.getChildren().remove(overlay);
        });

        Button btnCancel = new Button("ANNULER");
        btnCancel.setPrefSize(150, 65);
        btnCancel.setStyle(
                "-fx-background-color: #eceff1; -fx-background-radius: 15; -fx-font-weight: 900; -fx-text-fill: #455a64;");
        btnCancel.setOnAction(e -> rootStack.getChildren().remove(overlay));

        actions.getChildren().addAll(btnAdd, btnCancel);
        stepsContainer.getChildren().addAll(step1, step2, step3, step4, step5);

        ScrollPane scroll = new ScrollPane(stepsContainer);
        scroll.setFitToWidth(true);
        scroll.setHbarPolicy(ScrollPane.ScrollBarPolicy.NEVER);
        scroll.setStyle("-fx-background: transparent; -fx-background-color: transparent; -fx-padding: 10;");
        VBox.setVgrow(scroll, Priority.ALWAYS);

        container.getChildren().addAll(title, scroll, summaryLabel, actions);
        overlay.getChildren().add(container);
        rootStack.getChildren().add(overlay);
    }

    private VBox createMultiStepContainer(String title, String[][] options,
            java.util.function.Consumer<java.util.List<String>> onUpdate) {
        VBox container = new VBox(10);
        container.setAlignment(Pos.CENTER_LEFT);
        Label lblTitle = new Label(title);
        lblTitle.setStyle("-fx-font-size: 14px; -fx-font-weight: 900; -fx-text-fill: #607d8b; -fx-padding: 0 0 5 0;");

        HBox cards = new HBox(12);
        cards.setAlignment(Pos.CENTER_LEFT);

        java.util.List<String> selectedItems = new java.util.ArrayList<>();

        for (String[] opt : options) {
            VBox card = new VBox(5);
            card.setAlignment(Pos.CENTER);
            card.setPadding(new Insets(8));
            card.setPrefSize(130, 130);
            card.setStyle(
                    "-fx-background-color: white; -fx-background-radius: 15; -fx-border-color: #eee; -fx-border-width: 1; -fx-border-radius: 15; -fx-cursor: hand; -fx-effect: dropshadow(three-pass-box, rgba(0,0,0,0.03), 10, 0, 0, 5);");

            StackPane img = new StackPane();
            img.setPrefHeight(85);
            img.setStyle("-fx-background-image: url('" + opt[1]
                    + "'); -fx-background-size: cover; -fx-background-position: center; -fx-background-radius: 10;");
            Label name = new Label(opt[0]);
            name.setStyle("-fx-font-weight: bold; -fx-font-size: 12px; -fx-text-fill: #263238;");

            card.getChildren().addAll(img, name);
            card.setOnMouseClicked(e -> {
                if (selectedItems.contains(opt[0])) {
                    selectedItems.remove(opt[0]);
                    card.setStyle(
                            "-fx-background-color: white; -fx-background-radius: 15; -fx-border-color: #eee; -fx-border-width: 1; -fx-border-radius: 15; -fx-cursor: hand;");
                } else {
                    selectedItems.add(opt[0]);
                    card.setStyle(
                            "-fx-background-color: #fdf2f2; -fx-background-radius: 15; -fx-border-color: #D32F2F; -fx-border-width: 2; -fx-border-radius: 15; -fx-cursor: hand;");
                }
                onUpdate.accept(selectedItems);
            });
            cards.getChildren().add(card);
        }

        ScrollPane rowScroll = new ScrollPane(cards);
        rowScroll.setFitToHeight(true);
        rowScroll.setVbarPolicy(ScrollPane.ScrollBarPolicy.NEVER);
        rowScroll.setHbarPolicy(ScrollPane.ScrollBarPolicy.AS_NEEDED);
        rowScroll.setStyle("-fx-background: transparent; -fx-background-color: transparent;");
        container.getChildren().addAll(lblTitle, rowScroll);
        return container;
    }

    private VBox createStepContainer(String title, String[][] options, java.util.function.Consumer<String> onSelect) {
        VBox container = new VBox(10);
        container.setAlignment(Pos.CENTER_LEFT);

        Label lblTitle = new Label(title);
        lblTitle.setStyle("-fx-font-size: 14px; -fx-font-weight: 900; -fx-text-fill: #607d8b; -fx-padding: 0 0 5 0;");

        HBox cards = new HBox(12);
        cards.setAlignment(Pos.CENTER_LEFT);

        for (String[] opt : options) {
            VBox card = new VBox(5);
            card.setAlignment(Pos.CENTER);
            card.setPadding(new Insets(8));
            card.setPrefSize(130, 130);
            card.setStyle(
                    "-fx-background-color: white; -fx-background-radius: 15; -fx-border-color: #eee; -fx-border-width: 1; -fx-border-radius: 15; -fx-cursor: hand; -fx-effect: dropshadow(three-pass-box, rgba(0,0,0,0.03), 10, 0, 0, 5);");

            StackPane img = new StackPane();
            img.setPrefHeight(85);
            img.setStyle("-fx-background-image: url('" + opt[1]
                    + "'); -fx-background-size: cover; -fx-background-position: center; -fx-background-radius: 10;");

            Label name = new Label(opt[0]);
            name.setStyle("-fx-font-weight: bold; -fx-font-size: 12px; -fx-text-fill: #263238;");

            card.getChildren().addAll(img, name);
            card.setOnMouseClicked(e -> {
                onSelect.accept(opt[0]);
                cards.getChildren().forEach(n -> n.setStyle(
                        "-fx-background-color: white; -fx-background-radius: 15; -fx-border-color: #eee; -fx-border-width: 1; -fx-border-radius: 15; -fx-cursor: hand;"));
                card.setStyle(
                        "-fx-background-color: #fdf2f2; -fx-background-radius: 15; -fx-border-color: #D32F2F; -fx-border-width: 2; -fx-border-radius: 15; -fx-cursor: hand;");
            });
            cards.getChildren().add(card);
        }

        ScrollPane rowScroll = new ScrollPane(cards);
        rowScroll.setFitToHeight(true);
        rowScroll.setVbarPolicy(ScrollPane.ScrollBarPolicy.NEVER);
        rowScroll.setHbarPolicy(ScrollPane.ScrollBarPolicy.AS_NEEDED);
        rowScroll.setStyle("-fx-background: transparent; -fx-background-color: transparent;");

        container.getChildren().addAll(lblTitle, rowScroll);
        return container;
    }

    private void updateFormuleLabel(Label l, String[] s) {
        java.util.List<String> parts = new java.util.ArrayList<>();
        for (int i = 0; i < 4; i++)
            if (!s[i].equals("Sans"))
                parts.add(s[i]);
        if (s[4] != null && !s[4].isEmpty())
            parts.add(s[4]);
        l.setText("VOTRE CHOIX : " + String.join(" + ", parts));
    }

    private HBox createTotalRow(String label, Label valueNode, boolean isGrandTotal) {
        HBox row = new HBox();
        row.getStyleClass().add(isGrandTotal ? "total-row-grand" : "total-row");
        row.setAlignment(Pos.CENTER_LEFT);

        Label l = new Label(label);
        Region r = new Region();
        HBox.setHgrow(r, Priority.ALWAYS);

        valueNode.setPrefWidth(80);
        valueNode.setAlignment(Pos.CENTER_RIGHT);

        row.getChildren().addAll(l, r, valueNode);
        return row;
    }

    public static void main(String[] args) {
        launch(args);
    }
}
