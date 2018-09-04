/**
 * Created by dkovalchuk on 10-Apr-18.
 */

public class IP_AccountTabsExampleController {
    public List<Account> accounts { get; set; }

    public IP_AccountTabsExampleController() {
        this.accounts = [SELECT Id, Name FROM Account LIMIT 20];
    }

    public Component.Apex.TabPanel getTabs() {
        Component.Apex.TabPanel tabPanel = new Component.Apex.TabPanel();
        tabPanel.switchType = 'client';
        for (Integer counter = 0; counter < accounts.size(); counter++) {
            Component.Apex.Tab tab = new Component.Apex.Tab();
            tab.label = 'Account ' + counter;
            Component.Apex.OutputField outputField = new Component.Apex.OutputField();
            outputField.expressions.value = '{!accounts[ ' + counter + '].Id}';
            Component.Apex.InputField inputField = new Component.Apex.InputField();
            inputField.expressions.value = '{!accounts[ ' + counter + '].Name}';
            tab.childComponents.add(outputField);
            tab.childComponents.add(inputField);
            tabPanel.childComponents.add(tab);
        }
        return tabPanel;
    }


}