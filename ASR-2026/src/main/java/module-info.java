module com.elite.asr {
    requires javafx.controls;
    requires javafx.graphics;
    requires javafx.fxml;
    requires org.kordamp.ikonli.javafx;
    requires org.kordamp.ikonli.fontawesome5;
    requires com.fasterxml.jackson.databind;

    opens com.elite.asr to javafx.fxml, javafx.graphics;

    exports com.elite.asr;
}
