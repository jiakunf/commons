function findMice(src,~)

figHand = get(src,'parent');

% get UI data

h.animal_id1 = findobj(figHand,'tag','animalID1');
h.animal_id2 = findobj(figHand,'tag','animalID2');
h.animal_id3 = findobj(figHand,'tag','animalID3');
h.animal_id4 = findobj(figHand,'tag','animalID4');
h.animal_id5 = findobj(figHand,'tag','animalID5');
h.animal_id6 = findobj(figHand,'tag','animalID6');
h.animal_id7 = findobj(figHand,'tag','animalID7');
h.animal_id8 = findobj(figHand,'tag','animalID8');
h.animal_id9 = findobj(figHand,'tag','animalID9');
h.animal_id10 = findobj(figHand,'tag','animalID10');
h.animal_id11 = findobj(figHand,'tag','animalID11');
h.animal_id12 = findobj(figHand,'tag','animalID12');
h.animal_id13 = findobj(figHand,'tag','animalID13');
h.range_start = findobj(figHand,'tag','rangeStart');
h.range_end = findobj(figHand,'tag','rangeEnd');
h.table = findobj(figHand,'tag','miceTable');

m.animal_id{1} = get(h.animal_id1,'string');
m.animal_id{2} = get(h.animal_id2,'string');
m.animal_id{3} = get(h.animal_id3,'string');
m.animal_id{4} = get(h.animal_id4,'string');
m.animal_id{5} = get(h.animal_id5,'string');
m.animal_id{6} = get(h.animal_id6,'string');
m.animal_id{7} = get(h.animal_id7,'string');
m.animal_id{8} = get(h.animal_id8,'string');
m.animal_id{9} = get(h.animal_id9,'string');
m.animal_id{10} = get(h.animal_id10,'string');
m.animal_id{11} = get(h.animal_id11,'string');
m.animal_id{12} = get(h.animal_id12,'string');
m.animal_id{13} = get(h.animal_id13,'string');
m.range_start = get(h.range_start,'string');
m.range_end = get(h.range_end,'string');

h.errorMessage = findobj(figHand,'tag','errorMessage');
h.errorBox = findobj(figHand,'tag','errorBox');

delete(h.errorMessage);
delete(h.errorBox);

set(h.table,'data',{})

% error checking
mouseCount = 0;
mouseID = {};
errorCount = 0;
errorString = {};

a = strcmp('',m.animal_id);
for i = 1:length(a)
    if a(i) == 0
        mouseCount = mouseCount + 1;
        mouseID{mouseCount} = m.animal_id{i};
    end
end

b = str2num(m.range_start):str2num(m.range_end);
for i = 1:length(b)
    mouseCount = mouseCount + 1;
    mouseID{mouseCount} = num2str(b(i));
end


if mouseCount == 0
    errorCount = errorCount + 1;
    errorString{errorCount} = 'Please enter a valid animal ID or range of IDs.';
end

if ~(length(unique(mouseID)) == length(mouseID))
    errorCount = errorCount + 1;
    errorString{errorCount} = 'An animal ID has been entered twice.';
end

for i = 1:length(mouseID)
    id{i} = fetch(mice.Mice & ['animal_id=' mouseID{i}]);
    if isempty(id{i})
        errorCount = errorCount + 1;
        errorString{errorCount} = ['The animal ID ' mouseID{i} ' does not exist in the database.'];
    end
end

for i = 1:length(mouseID)
    id{i} = fetch(mice.Death & ['animal_id=' mouseID{i}], '*');
    if ~isempty(id{i})
        dod = datestr(id{i}.dod,'mm/dd/yyyy');
        errorCount = errorCount + 1;
        errorString{errorCount} = ['The animalID ' mouseID{i} ' was euthanized on ' dod '.'];
    end
end

if ~isempty(errorString)
    h.errorMessage = uicontrol('style','text','String',['Cannot find mice due to the following errors: '], 'position', [160 370 300 29],'fontsize',14,'tag','errorMessage');
    h.errorBox = uicontrol('style','listbox','string',errorString,'tag','errorBox','position',[460 370 300 29]);
    h.isTransfer = findobj(figHand,'tag','submitTransferButton');
    h.isDeath = findobj(figHand,'tag','submitDeathButton');
    if ~isempty(h.isTransfer) || ~isempty(h.isDeath)
        set(h.errorMessage,'position',[160 470 300 29]);
        set(h.errorBox,'position',[460 470 300 29]);
    end
    return
end

mouseTable = cell(length(mouseID),7);
for i = 1:length(mouseID)
    mouseTable{i,1} = mouseID{i};
    genotypes = fetch(mice.Genotypes & ['animal_id=' mouseID{i}],'*');
    for j = 1:size(genotypes,1)
        mouseTable{i,2*j} = genotypes(j).line;
        mouseTable{i,(2*j+1)} = genotypes(j).genotype;
    end
end
set(h.table,'data',mouseTable);

end
